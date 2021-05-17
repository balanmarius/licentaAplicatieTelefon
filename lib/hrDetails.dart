import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HrDetails extends StatefulWidget {
  @override
  _HrDetailsState createState() => _HrDetailsState();
}

class HrData {
  HrData(this.when, this.hr);
  final String when;
  final int hr;
}

class _HrDetailsState extends State<HrDetails> {
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("stats")
              .orderBy("date")
              .snapshots(),
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

              LineSeries<HrData, String> _createChart(month, day) {
                List<HrData> _chartData = <HrData>[];
                var i = 0;
                snapshot.data.docs.forEach(
                  (DocumentSnapshot document) {
                    if (document.data()['date'].toDate().month == month &&
                        document.data()['date'].toDate().day == day) {
                      var value = document.data()["HR"];
                      if (value.runtimeType == String) {
                        value = int.parse(document.data()["HR"]);
                      }
                      i++;
                      // _chartData.add(HrData(i.toString(), value));
                      _chartData.add(
                        HrData(
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
                  },
                );

                return LineSeries<HrData, String>(
                  name: "HR",
                  dataSource: _chartData,
                  xValueMapper: (HrData hr, _) => hr.when,
                  yValueMapper: (HrData hr, _) => hr.hr,
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                  enableTooltip: true,
                );
              }

              return ListView(
                children: <Widget>[
                  CarouselSlider(
                    items: [
                      for (var i = 1; i <= now.day; ++i)
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          padding: EdgeInsets.only(top: 60.0),
                          child: SfCartesianChart(
                            title: ChartTitle(
                                text: "HR through the day - " +
                                    i.toString() +
                                    " " +
                                    months[now.month - 1]),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[_createChart(now.month, i)],
                            primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'Number of recordings'),
                            ),
                            primaryYAxis: NumericAxis(
                              visibleMaximum: 200,
                              labelFormat: '{value} bpm',
                              plotBands: <PlotBand>[
                                PlotBand(
                                    verticalTextPadding: '5%',
                                    horizontalTextPadding: '5%',
                                    text: 'Too high',
                                    textAngle: 0,
                                    start: 170,
                                    end: 170,
                                    textStyle: TextStyle(
                                        color: Colors.deepOrange, fontSize: 16),
                                    borderColor: Colors.red,
                                    borderWidth: 2)
                              ],
                            ),
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
