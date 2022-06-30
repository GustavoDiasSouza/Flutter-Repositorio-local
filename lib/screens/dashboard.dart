import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          SingleChildScrollView(
            //Criado para Adaptar aos tamanhos de tela / Pode ser utilizado um container com um listview
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FeatureItem(
                  "Transferências",
                  Icons.monetization_on,
                  onClick: () => _showContactsList(context),
                ),
                _FeatureItem(
                  "Histórico",
                  Icons.description,
                  onClick: () => _showTransactionsList(context),
                ),
                _FeatureItem(
                  "Perfil",
                  Icons.person,
                  onClick: () {
                    print("Perfil");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showContactsList(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ContactsList(),
    ));
  }

  _showTransactionsList(BuildContext context) {

    FirebaseCrashlytics.instance.crash();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TransactionsList(),
    ));
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick; //Callback

  const _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.indigo,
        child: InkWell(
          onTap: () => onClick(),
          child: Ink(
            padding: const EdgeInsets.all(8.0),
            height: 100,
            width: 150,
            color: Colors.indigo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
