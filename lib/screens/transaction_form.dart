
import 'dart:async';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionwebClient _webClient = TransactionwebClient();
  final String transactionId = Uuid().v4();

  bool _sending = false;

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: const Text('Nova Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: _sending,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Progress(
                  message: 'Enviando...',
                ),
              ),
            ),
            Text(
              widget.contact.name,
              style: const TextStyle(
                fontSize: 34.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.contact.accountNumber.toString(),
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: TextField(
                controller: _valueController,
                style: const TextStyle(fontSize: 24.0),
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('Transferir'),
                  onPressed: () {
                    final double? value = double.tryParse(_valueController.text);
                    final transactionCreated = Transaction(
                      transactionId,
                      value!,
                      widget.contact,
                    );
                    showDialog(
                        context: context,
                        builder: (contextDialog) {
                          return TransactionAuthDialog(
                            onConfirm: (String password) {
                              _save(transactionCreated, password, context);
                            },
                          );
                        });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction? transaction = await _send(
      transactionCreated,
      password,
      context,
    );

    _showSucessFulMessage(transaction, context);
  }

  Future<void> _showSucessFulMessage(Transaction? transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Sucesso');
          }).then((value) => Navigator.pop(context));
    }
  }

  Future<Transaction?> _send(Transaction transactionCreated, String password, BuildContext context) async {
    setState(() {
      _sending = true;
    });
    final Transaction? transaction = await _webClient.save(transactionCreated, password).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('Exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('StatusCode', e.statusCode);
        FirebaseCrashlytics.instance.setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e.message, null);
      }

      _showFailereMessage(context, message: e.message);
    }, test: (e) => e is TimeoutException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('Exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('StatusCode', e.statusCode);
        FirebaseCrashlytics.instance.setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e.message, null);
      }

      _showFailereMessage(context, message: 'Tempo Esgotado!');
    }, test: (e) => e is HttpException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('Exception', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('StatusCode', e.statusCode);
        FirebaseCrashlytics.instance.setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e.message, null);
      }

      _showFailereMessage(context);
    }).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });

    return transaction;
  }

  void _showFailereMessage(
    BuildContext context, {
    String message = 'Parece que algo deu errado!',
  }) {
    //SnackBar
    final snackBar = SnackBar(content: Text(message));
    _scaffoldkey.currentState!.showSnackBar(snackBar);


    //Aviso Grande
    //   showDialog(
    //       context: context,
    //       builder: (contextDialog) {
    //         return FailureDialog(message);
    //       });
    // }
  }
}
