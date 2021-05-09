import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class LiveStepsPanel extends StatelessWidget {
  final channel = IOWebSocketChannel.connect('ws://192.168.100.30:3000/');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      child: Center(
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/steps.png',
                    filterQuality: FilterQuality.high),
                Text(
                  (snapshot.hasData ? '${snapshot.data.split(",")[0]}' : ''),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]),
                ),
                Text(
                  'STEPS',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
