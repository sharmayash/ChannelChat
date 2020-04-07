import 'package:flutter/material.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel =
      HtmlWebSocketChannel.connect('ws://echo.websocket.org');

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Channel Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? "${snapshot.data}" : "");
                }),
          ),
          Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurpleAccent, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Form(
                      child: TextFormField(
                        controller: _textC,
                        decoration: InputDecoration(
                            labelText: 'Send a message',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.green[500],
                      onPressed: _sendMessage)
                ],
              ))
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_textC.text.isNotEmpty) {
      widget.channel.sink.add(_textC.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close(status.goingAway);
    super.dispose();
  }
}
