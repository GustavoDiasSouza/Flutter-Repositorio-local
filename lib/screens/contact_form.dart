import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactForm extends StatefulWidget {
   ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                ),
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            TextField(
              controller: _accountNumberController,
              decoration: const InputDecoration(
                labelText: 'Número da Conta',
              ),
              style: const TextStyle(
                fontSize: 20.0,
              ),
              keyboardType: TextInputType.number,
            ),
             Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: double.maxFinite,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () {
                    final String name = _nameController.text;
                    final int? accountNumber = int.tryParse(_accountNumberController.text);

                    final Contact newContact = Contact(0 ,name, accountNumber!);
                    Navigator.pop(context,newContact);
                  },
                  child: const Text(
                    'Criar',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
