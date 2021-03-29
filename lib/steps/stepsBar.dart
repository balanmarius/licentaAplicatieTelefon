import 'package:flutter/material.dart';

import 'stepsDetails.dart';

class StepsBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0,50,0,0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                minWidth: double.infinity,
                child: Text(
                  'View your steps statistics',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StepsDetails()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
