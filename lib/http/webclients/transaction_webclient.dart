import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionwebClient {
//Precisa estar na mesma rede
  Future<List<Transaction>> findAlL() async {
    final Response response = await client
        .get(Uri.parse(baseUrl))
        .timeout(const Duration(seconds: 15));

    final List<dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(Uri.parse(baseUrl),
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    if (response.statusCode == 400) {
      throw Exception('Ocorreu um erro no envio da transferência!');
    } else if (response.statusCode == 401) {
      throw Exception('Falha na autenticação!');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
