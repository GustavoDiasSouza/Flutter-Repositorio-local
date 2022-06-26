import 'package:bytebank/components/progress.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';

import '../database/dao/contact_dao.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: const [],
        future: Future.delayed(const Duration(seconds: 0))
            .then((value) => _dao.findAll()),
        //Pode Remover o Delay, esta mais a fim de teste.
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data
                  as List<Contact>; //Melhorado com o as List<Contact>.
              return ListView.builder(
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return _ContactItem(
                    contact,
                    onclick: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TransactionForm(contact),
                      ));
                    },
                  );
                },
                itemCount: contacts.length,
              );
          }

          return const Text('Não foi possível carregar a lista.');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const ContactForm(),
                ),
              )
              .then((value) => setState(() {}));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onclick;

  const _ContactItem(
    this.contact, {
    required this.onclick,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        onTap: () => onclick(),
        title: Text(
          contact.name,
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(contact.accountNumber.toString(),
            style: const TextStyle(
              fontSize: 16.0,
            )),
      ),
    );
  }
}
