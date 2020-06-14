import 'package:flutter_chat_ui/models/message_model.dart';

import 'database.dart';


class Repository {
// Instancia do Database Helper
  DatabaseHelper _databaseHelper;
  // Construtor
  Repository() {
    _databaseHelper = new DatabaseHelper();
  }

  Future<List<Message>> findAll() async {
    var connection = await _databaseHelper.connection;
    var result = await connection.query(
      "MENSAGEM",
      columns: [
        "TEXTO",
        "HORARIO",
        "EU",
      ],
    );
        List<Message> mensagens = new List<Message>();
    for (Map i in result) {
      mensagens.add(Message.fromMap(i));
    }
    return mensagens;
  } 

  Future<int> create(Message messagem) async {
    var connection = await _databaseHelper.connection;
    var result = await connection.insert(
      "MENSAGEM",
      messagem.toMap(),
    );
    return result;
  }

Future<Message> getLast() async {
    var connection = await _databaseHelper.connection;
    List<Map> results = await connection.query(
      "messagem",
      columns: [
        "TEXTO",
        "HORARIO",
        "EU",
      ],
      orderBy: "HORARIO"
    );
    if (results.length > 0) {
      return Message.fromMap(results.last);
    } else {
      return null;
    }
  }

}