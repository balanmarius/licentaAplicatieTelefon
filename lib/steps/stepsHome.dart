import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class StepsHome extends StatelessWidget {
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
              Image.asset('assets/images/steps.png'),
              Text(
                (snapshot.hasData ? '${snapshot.data}' : ''),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
              Text(
                'steps',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
            ],
          );
        },
      )
          // child: Column(
          //   //mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Image.asset('assets/images/steps.png'),
          //     Text(
          //       '6000',
          //       style: TextStyle(
          //           fontSize: 25,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.blue[900]),
          //     ),
          //     Text(
          //       'steps',
          //       style: TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.blue[900]),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
