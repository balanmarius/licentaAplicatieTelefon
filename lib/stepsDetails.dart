import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginapp/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/homepage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:charts_common/common.dart' as chartsCommon;
import 'package:carousel_slider/carousel_slider.dart';

class StepsDetails extends StatefulWidget {
  StepsDetails() : super();

  @override
  _StepsDetailsState createState() => _StepsDetailsState();
}

class Steps {
  final String when;
  final int steps;

  Steps(this.when, this.steps);
}

class _StepsDetailsState extends State<StepsDetails> {
  List<charts.Series> seriesListMonth;
  List<charts.Series> seriesListDay;
  List<charts.Series> seriesListWeek;
  List<charts.Series> seriesListYear;

  barChartMonth(series,avg, month) {
    var _series=series;
    return charts.BarChart(
      _series,
      animate: true,
      vertical: true,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(),
      ),
      behaviors: [
        new charts.ChartTitle(month,
            behaviorPosition: charts.BehaviorPosition.top,
            titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 25),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle(
            'Average: ' + avg.toStringAsFixed(0),
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 17),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea)
      ],
    );
  }

  barChartDay() {
    return charts.BarChart(
      seriesListDay,
      animate: true,
      vertical: true,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(),
      ),
    );
  }

  barChartWeek() {
    return charts.BarChart(
      seriesListWeek,
      animate: true,
      vertical: true,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(),
      ),
    );
  }

  barChartYear() {
    return charts.BarChart(
      seriesListYear,
      animate: true,
      vertical: true,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  bool _visibilityDay = false;
  bool _visibilityWeek = false;
  bool _visibilityMonth = true;
  bool _visibilityYear = false;
  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "day") {
        _visibilityDay = visibility;
        _visibilityMonth = false;
        _visibilityWeek = false;
        _visibilityYear = false;
      }
      if (field == "week") {
        _visibilityWeek = visibility;
        _visibilityDay = false;
        _visibilityMonth = false;
        _visibilityYear = false;
      }
      if (field == "month") {
        _visibilityMonth = visibility;
        _visibilityDay = false;
        _visibilityWeek = false;
        _visibilityYear = false;
      }
      if (field == "year") {
        _visibilityYear = visibility;
        _visibilityDay = false;
        _visibilityWeek = false;
        _visibilityMonth = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("stats")
            .orderBy("date")
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (streamSnapshot.hasData) {
            /////////////variables/////////////////////////////////////////
            DateTime now = new DateTime.now();
            var data = {
              1: {},
              2: {},
              3: {},
              4: {},
              5: {},
              6: {},
              7: {},
              8: {},
              9: {},
              10: {},
              11: {},
              12: {}
            };
            var arr = [];
            var day;
            var maxSteps = -1;
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

            //////////////////////////////////////////////////////////////////
            streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
              var newDay = document.data()['date'].toDate().day;
              if (newDay != day && day != null) {
                print(day);
                arr.add(maxSteps);
                maxSteps = -1;
              }
              day = document.data()['date'].toDate().day;
              if (document.data()['steps'] > maxSteps) {
                maxSteps = document.data()['steps'];
                data[document.data()['date'].toDate().month][day] = maxSteps;
              }
            });
            //pt ultima zi
            print(day);
            arr.add(maxSteps);
            print(arr);
            //media pasilor pe luna
            for (var i = 0; i < data.length; ++i) {
              if (data[i] != null) {
                var sum = 0;
                for (var j = 1; j < 31; ++j) {
                  if (data[i][j] != null) {
                    sum += data[i][j];
                  }
                }
                print(data[i].length);
                data[i]['avgStepsMonth'] = sum / data[i].length;
              }
            }
            print(data);

            //vector pt media pasilor pe luna
            var averages = [];
            for (var i = 0; i < data.length; ++i) {
              if (data[i] != null) {
                averages.add(data[i]['avgStepsMonth']);
              }
            }
            print(averages);

            //chart month
            List<charts.Series<Steps, String>> _createMonthChart(month) {
              List<Steps> stepsPerDay = [];
              streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
                if (document.data()['date'].toDate().month == month) {
                  stepsPerDay.add(Steps(
                      document.data()['date'].toDate().day.toString(),
                      document.data()['steps']));
                }
              });

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: stepsPerDay,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            seriesListMonth = _createMonthChart(now.month-1);

            //chart day
            List<charts.Series<Steps, String>> _createDayChart() {
              List<Steps> stepsPerDay = [];
              streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
                if (document.data()['date'].toDate().day == 29) {
                  stepsPerDay.add(Steps(
                      document.data()['date'].toDate().hour.toString(),
                      document.data()['steps']));
                }
              });

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: stepsPerDay,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            seriesListDay = _createDayChart();

            //chart week
            List<charts.Series<Steps, String>> _createWeekChart() {
              List<Steps> stepsPerDay = [];
              streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
                // now.day o sa fie in loc de 29
                var min = 25 - 7;
                if (document.data()['date'].toDate().day <= 25 &&
                    document.data()['date'].toDate().day > min) {
                  stepsPerDay.add(Steps(
                      document.data()['date'].toDate().day.toString(),
                      document.data()['steps']));
                }
              });

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: stepsPerDay,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            seriesListWeek = _createWeekChart();

            //chart year
            List<charts.Series<Steps, String>> _createYearChart() {
              List<Steps> stepsPerDay = [];
              streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
                if (document.data()['date'].toDate().year == 2021) {
                  stepsPerDay.add(Steps(
                      months[document.data()['date'].toDate().month - 1],
                      int.parse(
                          averages[document.data()['date'].toDate().month - 1]
                              .toStringAsFixed(0))));
                }
              });

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: stepsPerDay,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            seriesListYear = _createYearChart();

            //////////////////////////////////////////////////////draw on screen/////////////////////////////////////////////
            return ListView(
              children: <Widget>[
                Container(
                  child: new Center(
                    child: new ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ElevatedButton(
                          child: new Text('D'),
                          onPressed: () {
                            _visibilityDay ? null : _changed(true, "day");
                          },
                        ),
                        new ElevatedButton(
                          child: new Text('W'),
                          onPressed: () {
                            _visibilityWeek ? null : _changed(true, "week");
                          },
                        ),
                        new ElevatedButton(
                          child: new Text('M'),
                          onPressed: () {
                            _visibilityMonth ? null : _changed(true, "month");
                          },
                        ),
                        new ElevatedButton(
                          child: new Text('Y'),
                          onPressed: () {
                            _visibilityYear ? null : _changed(true, "year");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _visibilityMonth,
                  child: CarouselSlider(
                    items: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        padding: EdgeInsets.all(20.0),
                        child: barChartMonth(seriesListMonth, averages[3], months[3]),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        padding: EdgeInsets.all(20.0),
                        child: barChartMonth(_createMonthChart(now.month),averages[4], months[4]),
                      ),
                    ],
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.7,
                      enlargeCenterPage: true,
                      aspectRatio: 1/1,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                    ),
                  ),
                ),
                Visibility(
                  visible: _visibilityDay,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.all(20.0),
                    child: barChartDay(),
                  ),
                ),
                Visibility(
                  visible: _visibilityWeek,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.all(20.0),
                    child: barChartWeek(),
                  ),
                ),
                Visibility(
                  visible: _visibilityYear,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.all(20.0),
                    child: barChartYear(),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: streamSnapshot.data.docs.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text('This works'),
            ),
          );
        },
      ),
    );
  }
}
