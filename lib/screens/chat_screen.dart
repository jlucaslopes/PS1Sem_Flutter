import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/database/repository.dart';
import 'package:flutter_chat_ui/models/message_model.dart';
import 'package:date_format/date_format.dart';



class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<List<Message>> mensagens = Repository().findAll();

 
  
  _buildMessage(Message message) {
    if (message.texto != null) {
      final Container msg = Container(
        margin: message.eu == 1
            ? EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 80.0,
              )
            : EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: message.eu == 1
              ? Theme.of(context).accentColor
              : Color(0xFFFFEFEE),
          borderRadius: message.eu == 1
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.horario,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              message.texto,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

      return msg;
    }
    return null;
  }

  _buildMessageComposer() {
    TextEditingController inputController = new TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: inputController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Digite a mensagem...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if(inputController.text != null) {  
                   
              setState(() {
                      Repository().create(new Message(
                eu: 1,
                horario: formatDate(DateTime.now(), [HH,':',nn]),
                texto: inputController.text,
              ));
              inputController.text = null;
              }
              );
              
              }
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'ROBOT',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: FutureBuilder<List<Message>>(
                      future: Repository().findAll(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: 15.0),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              Message message = snapshot.data[index];
                              if (message == null) {
                                return null;
                              }
                              return _buildMessage(message);
                            },
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
