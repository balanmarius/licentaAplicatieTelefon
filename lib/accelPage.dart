import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_common/src/common/text_style.dart' as style;

class AccelPage extends StatefulWidget {
  @override
  _AccelPageState createState() => _AccelPageState();
}

class AccelData {
  AccelData(this.when, this.accel);
  final String when;
  final double accel;
}

class _AccelPageState extends State<AccelPage> {
  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("stats")
              .orderBy("date")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              DateTime now = new DateTime.now();
              var months = [
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
              ];

              LineSeries<AccelData, String> _createChartX(month, day) {
                List<AccelData> _chartData = <AccelData>[];
                snapshot.data.docs.forEach(
                  (DocumentSnapshot document) {
                    if (document.data()['date'].toDate().month == month &&
                        document.data()['date'].toDate().day == day) {
                      var value = document.data()["accelerometerX"];
                      if (value != null && value != "unavailable") {
                        if (value == 0) {
                          value = 0.0;
                        }
                        _chartData.add(
                          AccelData(
                              document.data()['date'].toDate().hour.toString() +
                                  ":" +
                                  document
                                      .data()['date']
                                      .toDate()
                                      .minute
                                      .toString() +
                                  ":" +
                                  document
                                      .data()['date']
                                      .toDate()
                                      .second
                                      .toString(),
                              value),
                        );
                      }
                    }
                  },
                );

                return LineSeries<AccelData, String>(
                  name: "X",
                  dataSource: _chartData,
                  xValueMapper: (AccelData accelX, _) => accelX.when,
                  yValueMapper: (AccelData accelX, _) => accelX.accel,
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                  enableTooltip: true,
                  color: Colors.red[400],
                );
              }

              LineSeries<AccelData, String> _createChartY(month, day) {
                List<AccelData> _chartData = <AccelData>[];
                snapshot.data.docs.forEach(
                  (DocumentSnapshot document) {
                    if (document.data()['date'].toDate().month == month &&
                        document.data()['date'].toDate().day == day) {
                      var value = document.data()["accelerometerY"];
                      if (value != null && value != "unavailable") {
                        if (value == 0) {
                          value = 0.0;
                        }
                        _chartData.add(
                          AccelData(
                              document.data()['date'].toDate().hour.toString() +
                                  ":" +
                                  document
                                      .data()['date']
                                      .toDate()
                                      .minute
                                      .toString() +
                                  ":" +
                                  document
                                      .data()['date']
                                      .toDate()
                                      .second
                                      .toString(),
                              value),
                        );
                      }
                    }
                  },
                );

                return LineSeries<AccelData, String>(
                    name: "Y",
                    dataSource: _chartData,
                    xValueMapper: (AccelData accelY, _) => accelY.when,
                    yValueMapper: (AccelData accelY, _) => accelY.accel,
                    dataLabelSettings: DataLabelSettings(isVisible: false),
                    enableTooltip: true,
                    color: Colors.green[500]);
              }

              LineSeries<AccelData, String> _createChartZ(month, day) {
                List<AccelData> _chartData = <AccelData>[];
                snapshot.data.docs.forEach(
                  (DocumentSnapshot document) {
                    if (document.data()['date'].toDate().month == month &&
                        document.data()['date'].toDate().day == day) {
                      var value = document.data()["accelerometerZ"];
                      if (value != null && value != "unavailable") {
                        if (value == 0) {
                          value = 0.0;
                        }
                        _chartData.add(
                          AccelData(
                              document.data()['date'].toDate().hour.toString() +
                                  ":" +
                                  document
                                      .data()['date']
                                      .toDate()
                                      .minute
                                      .toString() +
                                  ":" +
                                  document
                                      .data()['date']
                                      .toDate()
                                      .second
                                      .toString(),
                              value),
                        );
                      }
                    }
                  },
                );

                return LineSeries<AccelData, String>(
                  name: "Z",
                  dataSource: _chartData,
                  xValueMapper: (AccelData accelZ, _) => accelZ.when,
                  yValueMapper: (AccelData accelZ, _) => accelZ.accel,
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                  enableTooltip: true,
                  color: Colors.blue[500],
                );
              }

              return ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Center(
                      child: Text(
                        "Short Introduction to Axes",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Text(
                          "X axis --> parallel with the device's screen, aligned with the top and bottom edges, in the left-right direction",
                          style:
                              TextStyle(color: Colors.red[400], fontSize: 16),
                        ),
                        Text(
                          "Y axis --> parallel with the device's screen, aligned with the left and right edges, in the top-bottom direction",
                          style:
                              TextStyle(color: Colors.green[500], fontSize: 16),
                        ),
                        Text(
                          "Z axis --> perpendicular to the device's screen, pointing up",
                          style:
                              TextStyle(color: Colors.blue[600], fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(100, 10, 100, 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[400], width: 3),
                    ),
                    child: Image.asset('assets/images/axes.png',
                        filterQuality: FilterQuality.high),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      "So, these being said, the values in the next graph can have the following meanings:\n" +
                          " --> if the values are continously changing, you are moving\n" +
                          " --> if the values do not change at all (3 flat lines) you are not moving\n" +
                          "With this graph, you can watch when you had active minutes (high variations), when you barely moved (low variations), and so on.\n" +
                          "Now, let's watch some stats!",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  CarouselSlider(
                    items: [
                      for (var i = 1; i <= now.day; ++i)
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: SfCartesianChart(
                            borderColor: Colors.blue[400],
                            borderWidth: 2,
                            title: ChartTitle(
                              text: "Accelerometer through the day - " +
                                  i.toString() +
                                  " " +
                                  months[now.month - 1],
                            ),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[
                              _createChartX(now.month, i),
                              _createChartY(now.month, i),
                              _createChartZ(now.month, i)
                            ],
                            primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'Time'),
                              maximumLabels: 2,
                            ),
                            primaryYAxis:
                                NumericAxis(anchorRangeToVisiblePoints: false),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.7,
                      enlargeCenterPage: true,
                      initialPage: now.day - 1,
                      enableInfiniteScroll: false,
                      aspectRatio: 1 / 1,
                      viewportFraction: 1,
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text('This works'),
              ),
            );
          },
        ),
      ),
    );
  }
}
