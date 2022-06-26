import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionwebClient {
//Precisa estar na mesma rede
  Future<List<Transaction>> findAlL() async {
    final Response response = await client.get(Uri.parse(baseUrl));

    final List<dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(Uri.parse(baseUrl),
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  String? _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }
    return 'Erros desconhecido!';
  }

  //Verifica qual foi o erro
  static final Map<int, String> _statusCodeResponses = {
    400: 'Ocorreu um erro no envio da transferência!',
    401: 'Falha na autenticação!',
    409: 'Transação em andamento!',
  };
}

class HttpException implements Exception {
  final String? message;

  HttpException(this.message);
}
