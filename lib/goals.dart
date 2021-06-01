import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Goals extends StatefulWidget {
  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  CollectionReference goals = FirebaseFirestore.instance.collection('goals');

  @override
  void dispose() {
    stepsController.dispose();
    caloriesController.dispose();
    super.dispose();
  }

  Future<void> addGoals(valueSteps, valueCalories) {
    goals.doc('calories goal').set({'value': valueCalories});
    goals.doc('steps goal').set({'value': valueSteps});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Steps goal:",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: stepsController,
                decoration: InputDecoration(
                  hintText: "Insert value for steps!",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Calories goal:",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: caloriesController,
                decoration: InputDecoration(
                  hintText: "Insert value for calories!",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(60, 0, 60, 20),
              child: MaterialButton(
                child: Text(
                  "Update daily goal!",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  FutureBuilder(
                    future: addGoals(stepsController.text, caloriesController.text),
                    builder: (context, snapshot) {
                      print("test");
                    },
                  );
                },
                textColor: Colors.white,
                color: Colors.blue[400],
              ),
            )
          ],
        ),
      ),
    );
  }
}
