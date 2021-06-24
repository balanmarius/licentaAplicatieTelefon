import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:charts_common/common.dart' as chartsCommon;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as styleCharts;
import 'package:flutter/src/painting/text_style.dart' as style;
import 'dart:ui';

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

//variabila care e afisata la click pe barchart
var temp;

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      Color fillColor,
      FillPatternType fillPattern,
      Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(
            bounds.left - 50, -50, bounds.width + 100, bounds.height + 50),
        fill: charts.Color.fromHex(code: '#9DF3EC'),
        stroke: charts.Color.fromHex(code: '#4174FF'),
        strokeWidthPx: 3);
    var textStyle = styleCharts.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 16;
    canvas.drawText(TextElement.TextElement(temp, style: textStyle),
        (bounds.left - 50).round(), -45);
  }
}

class _StepsDetailsState extends State<StepsDetails> {
  List<charts.Series> seriesListMonth;
  List<charts.Series> seriesListDay;
  List<charts.Series> seriesListWeek;
  List<charts.Series> seriesListYear;

  barChartStats(series) {
    var _series = series;
    return charts.BarChart(
      _series,
      animate: true,
      vertical: false,
      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
        strokeWidthPx: 1.0,
      ),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.GridlineRendererSpec(),
      ),
    );
  }

  barChartMonth(series, avg, month) {
    var _series = series;
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
        renderSpec: charts.SmallTickRendererSpec(
            labelRotation: 60, labelOffsetFromAxisPx: 5),
      ),
      behaviors: [
        new charts.ChartTitle(month,
            subTitle: 'Average: ' + avg.toStringAsFixed(0),
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: chartsCommon.TextStyleSpec(
              fontSize: 25,
            ),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        LinePointHighlighter(symbolRenderer: CustomCircleSymbolRenderer())
      ],
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              var nr = model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index)
                  .toString();
              if (nr == "0") {
                nr = "    " + nr.toString();
              }
              temp = " Total this day\n        " + nr;
            }
          },
        )
      ],
    );
  }

  barChartDay(series, title) {
    var _series = series;
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
        new charts.ChartTitle(title,
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 25),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        LinePointHighlighter(symbolRenderer: CustomCircleSymbolRenderer())
      ],
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              var nr = model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index);
              var time = model.selectedSeries[0]
                  .domainFn(model.selectedDatum[0].index);
              var timePlusOne = (int.parse(time) + 1).toString();
              if (time != null && time.toString().length == 1) {
                time = "0" + time;
              }
              if (timePlusOne != null &&
                  timePlusOne.length == 1 &&
                  int.parse(timePlusOne) < 10) {
                timePlusOne = "0" + timePlusOne;
              }

              temp = "        " +
                  nr.toString() +
                  "        \n" +
                  "steps between\n       " +
                  time +
                  "-" +
                  timePlusOne +
                  "       ";
            }
          },
        )
      ],
    );
  }

  barChartWeek(title) {
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
      behaviors: [
        new charts.ChartTitle(title,
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 25),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        LinePointHighlighter(symbolRenderer: CustomCircleSymbolRenderer())
      ],
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              var nr = model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index)
                  .toString();
              if (nr == "0") {
                nr = "    " + nr.toString();
              }
              temp = " Total this day\n        " + nr;
            }
          },
        )
      ],
    );
  }

  barChartYear(title) {
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
      behaviors: [
        new charts.ChartTitle(title,
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 25),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        LinePointHighlighter(symbolRenderer: CustomCircleSymbolRenderer())
      ],
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection) {
              var nr = model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index)
                  .toString();
              var month = model.selectedSeries[0]
                  .domainFn(model.selectedDatum[0].index)
                  .toString();
              if (nr == "0") {
                nr = "    " + nr.toString();
              }
              temp = "       Average\n        " + nr;
            }
          },
        )
      ],
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
      backgroundColor: Colors.blue[100],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("stepsGraph")
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
            var dataLastYear = {
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
            var count = streamSnapshot.data.size;
            // print(count);

            //////////////////////////////////////////////////////////////////
            streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
              var newDay = document.data()['date'].toDate().day;
              if (newDay != day && day != null) {
                // print(day);
                arr.add(maxSteps);
                maxSteps = -1;
              }
              day = document.data()['date'].toDate().day;
              if (document.data()['steps'] > maxSteps) {
                maxSteps = document.data()['steps'];
                if (document.data()['date'].toDate().year == now.year - 1) {
                  dataLastYear[document.data()['date'].toDate().month][day] =
                      maxSteps;
                } else {
                  data[document.data()['date'].toDate().month][day] = maxSteps;
                }
              }
            });
            //pt ultima zi
            // print(day);
            arr.add(maxSteps);
            // print(arr);
            //media pasilor pe luna
            for (var i = 1; i <= data.length; ++i) {
              if (data[i] != null) {
                var sum = 0;
                for (var j = 1; j < 31; ++j) {
                  if (data[i][j] != null) {
                    sum += data[i][j];
                  }
                }
                data[i]['avgStepsMonth'] = sum / data[i].length;
              }
            }
            // print(data);

            for (var i = 1; i <= dataLastYear.length; ++i) {
              if (dataLastYear[i] != null) {
                var sum = 0;
                for (var j = 1; j < 31; ++j) {
                  if (dataLastYear[i][j] != null) {
                    sum += dataLastYear[i][j];
                  }
                }
                dataLastYear[i]['avgStepsMonth'] = sum / dataLastYear[i].length;
              }
            }
            // print(dataLastYear);

            //vector pt media pasilor pe luna
            var averages = [];
            for (var i = 1; i <= data.length; ++i) {
              if (data[i] != null) {
                averages.add(data[i]['avgStepsMonth']);
              }
            }
            // print(averages);

            var averagesLastYear = [];
            for (var i = 1; i <= dataLastYear.length; ++i) {
              if (dataLastYear[i] != null) {
                averagesLastYear.add(dataLastYear[i]['avgStepsMonth']);
              }
            }
            // print(averagesLastYear);

            //chart month
            List<charts.Series<Steps, String>> _createMonthChart(month) {
              List<Steps> stepsPerDay = [];
              var newDay;
              var day;
              streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
                if (document.data()['date'].toDate().year == now.year &&
                    document.data()['date'].toDate().month == month) {
                  newDay = document.data()['date'].toDate().day;
                  if (newDay == day) {
                    stepsPerDay.removeLast();
                  }
                  day = document.data()['date'].toDate().day;
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

            //chart day
            List<charts.Series<Steps, String>> _createDayChart(day, month) {
              List<Steps> stepsPerDay = [];
              var newTime;
              var time;
              var sum = 0;
              var actualSteps;
              var dif;
              var total = 0;
              streamSnapshot.data.docs.forEach((DocumentSnapshot document) {
                if (document.data()['date'].toDate().day == day &&
                    document.data()['date'].toDate().month == month) {
                  newTime = document.data()['date'].toDate().hour;
                  if (newTime == time) {
                    dif = document.data()['steps'] - actualSteps;
                    sum = sum + dif;
                    stepsPerDay.removeLast();
                    total += dif;
                  } else {
                    sum = document.data()['steps'] - total;
                    total = document.data()['steps'];
                  }
                  actualSteps = document.data()['steps'];
                  time = document.data()['date'].toDate().hour;
                  stepsPerDay.add(Steps(
                      document.data()['date'].toDate().hour.toString(), sum));
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

            var avgThisWeek = 0;
            var avgLastWeek = 0;
            //chart week
            List<charts.Series<Steps, String>> _createWeekChart() {
              var countDays = 0;
              var day;
              var newDay;
              List<Steps> stepsPerDay = [];
              List<Steps> thisWeek = [];
              List<Steps> lastWeek = [];
              streamSnapshot.data.docs.forEach(
                (DocumentSnapshot document) {
                  newDay = document.data()['date'].toDate().day;
                  if (newDay == day) {
                    countDays--;
                    stepsPerDay.removeLast();
                  }
                  countDays++;
                  day = document.data()['date'].toDate().day;
                  stepsPerDay.add(Steps(
                      document.data()['date'].toDate().day.toString(),
                      document.data()['steps']));
                },
              );
              // print(countDays);
              if (countDays >= 14) {
                thisWeek = stepsPerDay.sublist(countDays - 7);
                lastWeek = stepsPerDay.sublist(countDays - 14, countDays - 7);
              }

              thisWeek.forEach((element) {
                avgThisWeek += element.steps;
              });
              lastWeek.forEach((element) {
                avgLastWeek += element.steps;
              });

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: thisWeek,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            seriesListWeek = _createWeekChart();
            avgThisWeek = int.parse((avgThisWeek / 7).toStringAsFixed(0));
            avgLastWeek = int.parse((avgLastWeek / 7).toStringAsFixed(0));

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

            List<charts.Series<Steps, String>> _createComparedMonths() {
              List<Steps> s = [];
              s.add(Steps(months[now.month - 1],
                  int.parse(averages[now.month - 1].toStringAsFixed(0))));
              s.add(Steps(months[now.month - 2],
                  int.parse(averages[now.month - 2].toStringAsFixed(0))));

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: s,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            String textStatsSteps1(month) {
              if (averages[month - 1] > averages[month - 2]) {
                return "This month, the average number of steps is bigger than last month.\n You had an increase of " +
                    (averages[month - 1] - averages[month - 2])
                        .toStringAsFixed(0) +
                    " steps.";
              } else {
                return "This month, the average number of steps is lower than last month.\n You had a decrease of " +
                    (averages[month - 2] - averages[month - 1])
                        .toStringAsFixed(0) +
                    " steps.";
              }
            }

            List<charts.Series<Steps, String>> _createComparedWeeks() {
              List<Steps> s = [];
              s.add(Steps("This week", avgThisWeek));
              s.add(Steps("Last week", avgLastWeek));

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: s,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            /////////////////////////////////////////////////////de adaugat zile sa am 14
            ///
            String textStatsSteps2() {
              if (avgLastWeek < avgThisWeek) {
                return "This week, the average number of steps per day is bigger than last week.\n You had an increase of " +
                    (avgThisWeek - avgLastWeek).toStringAsFixed(0) +
                    " steps.";
              }
              if (avgLastWeek > avgThisWeek) {
                return "This week, the average number of steps per day is lower than last week.\n You had a decrease of " +
                    (avgLastWeek - avgThisWeek).toStringAsFixed(0) +
                    " steps.";
              }
              return "Equal number of steps";
            }

            var avgThisYear = 0;
            averages.forEach((element) {
              if (element.toString() != "NaN") {
                avgThisYear += int.parse(element.toStringAsFixed(0));
              }
            });
            avgThisYear = int.parse((avgThisYear / 12).toStringAsFixed(0));
            // print(avgThisYear);
            var avgLastYear = 0;
            averagesLastYear.forEach((element) {
              if (element.toString() != "NaN") {
                avgLastYear += int.parse(element.toStringAsFixed(0));
              }
            });
            avgLastYear = int.parse((avgLastYear / 12).toStringAsFixed(0));
            // print(avgLastYear);
            List<charts.Series<Steps, String>> _createComparedYears() {
              List<Steps> s = [];
              s.add(Steps("This year", avgThisYear));
              s.add(Steps("Last year", avgLastYear));

              return [
                charts.Series<Steps, String>(
                  id: 'Steps',
                  domainFn: (Steps steps, _) => steps.when,
                  measureFn: (Steps steps, _) => steps.steps,
                  data: s,
                  fillColorFn: (Steps sales, _) {
                    return charts.MaterialPalette.blue.shadeDefault;
                  },
                )
              ];
            }

            String textStatsSteps3() {
              if (avgLastYear < avgThisYear) {
                return "This year, the average number of steps is bigger than last year.\n You had an increase of " +
                    (avgThisYear - avgLastYear).toStringAsFixed(0) +
                    " steps.";
              }
              if (avgLastYear > avgThisYear) {
                return "This year, the average number of steps is lower than last year.\n You had a decrease of " +
                    (avgLastYear - avgThisYear).toStringAsFixed(0) +
                    " steps.";
              }
            }

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
                      for (var i = 1; i <= now.month; ++i)
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          padding: EdgeInsets.only(top: 50.0),
                          child: barChartMonth(_createMonthChart(i),
                              averages[i - 1], months[i - 1]),
                        ),
                    ],
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.7,
                      enlargeCenterPage: true,
                      initialPage: now.month - 1,
                      enableInfiniteScroll: false,
                      aspectRatio: 1 / 1,
                      viewportFraction: 0.8,
                    ),
                  ),
                ),
                Visibility(
                  visible: _visibilityDay,
                  child: CarouselSlider(
                    items: [
                      for (var i = 1; i <= now.day; ++i)
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          padding: EdgeInsets.only(top: 60.0),
                          child: barChartDay(_createDayChart(i, now.month),
                              months[now.month - 1] + " " + i.toString()),
                        ),
                    ],
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.7,
                      enlargeCenterPage: true,
                      initialPage: now.day - 1,
                      enableInfiniteScroll: false,
                      aspectRatio: 1 / 1,
                      viewportFraction: 0.8,
                    ),
                  ),
                ),
                Visibility(
                  visible: _visibilityWeek,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.only(top: 60.0),
                    child: barChartWeek('Last 7 days'),
                  ),
                ),
                Visibility(
                  visible: _visibilityYear,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.only(top: 60.0),
                    child: barChartYear(now.year.toString()),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    border: Border.all(
                      width: 3,
                      color: Colors.blue[500],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        textStatsSteps1(now.month),
                        style: style.TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: barChartStats(_createComparedMonths()),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    border: Border.all(
                      width: 3,
                      color: Colors.blue[500],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        textStatsSteps2(),
                        style: style.TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: barChartStats(_createComparedWeeks()),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    border: Border.all(
                      width: 3,
                      color: Colors.blue[500],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        textStatsSteps3(),
                        style: style.TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: barChartStats(_createComparedYears()),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: EdgeInsets.all(30),
                  child: ListView(
                    children: <Widget>[
                      Text(
                          "Increasing physical activity such as your step count reduces your risk of death by improving your health, including by reducing risk of developing chronic illnesses such as dementia, and certain cancers. In some cases it helps improve health conditions such as type 2 diabetes.",
                          style: style.TextStyle(fontSize: 17))
                    ],
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
