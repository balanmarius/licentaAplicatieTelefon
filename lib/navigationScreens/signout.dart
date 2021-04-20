import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Signout extends StatelessWidget {
  final channel = IOWebSocketChannel.connect('ws://192.168.100.30:3000/');

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Text('Sign out'),
    // );
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        return Text(snapshot.hasData ? '${snapshot.data}' : '');
      },
    );
  }
}
