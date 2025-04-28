import 'dart:io';

import 'package:barbell_velocity/function.dart';
import 'package:barbell_velocity/graph_page.dart';
import 'package:barbell_velocity/models/results_path.dart';
import 'package:barbell_velocity/models/results_repetition.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RepetitionPage extends StatefulWidget {
  final int exerciseId;
  final String filename;
  final String intensity;

  const RepetitionPage({
    super.key,
    required this.exerciseId,
    required this.filename,
    required this.intensity,
  });

  @override
  State<RepetitionPage> createState() => _RepetitionPageState();
}

class _RepetitionPageState extends State<RepetitionPage> {
  late Future<List<ResultsRepetition>> futureResultsRepetition;
  late Future<List<ResultsPath>> futureResultsPath;
  File? summaryFile;
  void getImage() async {
    try {
      final imageFile = await getSummary(widget.filename);
      if (mounted) {
        setState(() {
          summaryFile = imageFile;
        });
      }
    } catch (e) {
      print('error ${e}');
    }
    if (summaryFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GraphPage(summaryFile: summaryFile!)));
    }
  }

  @override
  void initState() {
    super.initState();
    futureResultsRepetition = fetchResultsRepetition(widget.exerciseId);
    futureResultsPath = fetchResultsPath(widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_9.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.teal, size: 25),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: 160,
                    height: 160,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal,
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Icon(
                            Icons.speed,
                            color: Colors.teal,
                            size: 30,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder(
                              future: futureResultsRepetition,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<ResultsRepetition> results =
                                      snapshot.data!;
                                  double sumVelocityC = 0.0;
                                  double mv = 0.0;

                                  if (results.isNotEmpty) {
                                    for (var result in results) {
                                      sumVelocityC += result.velocityC;
                                    }
                                    mv = sumVelocityC / results.length;
                                  }

                                  return Text(
                                    mv.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.white),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Snapshot error: ${snapshot.error}');
                                }

                                return Center(
                                    child: const CircularProgressIndicator());
                              }),
                          Text(
                            'm/s',
                            style: TextStyle(color: Colors.teal, fontSize: 17),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "\nMean Velocity\n",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "${widget.intensity}\n",
                      style: TextStyle(
                        color: widget.intensity == "Heavy"
                            ? Colors.red
                            : widget.intensity == "Moderate"
                                ? Colors.orange
                                : Colors.green,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 150,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            // border: Border.all(
                            //   color: Colors.white,
                            // ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.keyboard_double_arrow_down,
                              color: Colors.teal,
                              size: 40,
                            ),
                            FutureBuilder(
                                future: futureResultsRepetition,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<ResultsRepetition> results =
                                        snapshot.data!;
                                    double vl = 0.0;

                                    if (results.isNotEmpty) {
                                      vl = results[results.length - 1]
                                          .velocityLoss;
                                    }

                                    return Tooltip(
                                      message: vl.round() >= 25 &&
                                              vl.round() < 40
                                          ? 'Your set is ideal for muscle hypertrophy!'
                                          : vl.round() >= 40
                                              ? 'Good job, that set was until failure but be careful!'
                                              : 'Your set is ideal for maximum strength development!',
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '-${vl.toStringAsFixed(2)} %',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Snapshot error: ${snapshot.error}');
                                  }

                                  return Center(
                                      child: const CircularProgressIndicator());
                                }),
                            Text(
                              'Velocity Loss',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 10,),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 150,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            // border: Border.all(
                            //   color: Colors.white,
                            // ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.rocket_launch,
                              color: Colors.teal,
                              size: 40,
                            ),
                            FutureBuilder(
                                future: futureResultsRepetition,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<ResultsRepetition> results =
                                        snapshot.data!;
                                    double peak = 0.0;
                                    int rep = 0;

                                    if (results.isNotEmpty) {
                                      for (var result in results) {
                                        if (result.velocityC > peak) {
                                          peak = result.velocityC;
                                          rep = result.repetition;
                                        }
                                      }
                                    }

                                    return Tooltip(
                                      message:
                                          'Your best execution was on repetition $rep!',
                                      textStyle: TextStyle(color: Colors.white),
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${peak.toStringAsFixed(2)} m/s',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Snapshot error: ${snapshot.error}');
                                  }

                                  return Center(
                                      child: const CircularProgressIndicator());
                                }),
                            Text(
                              'Peak Velocity',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 28),
                    height: 180,
                    child: FutureBuilder<List<ResultsRepetition>>(
                        future: futureResultsRepetition,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<ResultsRepetition> results = snapshot.data!;
                            List<FlSpot> concentricData = results
                                .map((result) => FlSpot(
                                    result.repetition.toDouble(),
                                    result.velocityC))
                                .toList();
                            List<FlSpot> eccentricData = results
                                .map((result) => FlSpot(
                                    result.repetition.toDouble(),
                                    result.velocityE))
                                .toList();
                            return LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                lineBarsData: [
                                  LineChartBarData(
                                    preventCurveOverShooting: true,
                                    spots: concentricData,
                                    isCurved: true,
                                    color: Colors.teal,
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                  LineChartBarData(
                                    preventCurveOverShooting: true,
                                    spots: eccentricData,
                                    isCurved: true,
                                    color: Colors.red,
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Snapshot error: ${snapshot.error}');
                          }

                          return Center(
                              child: const CircularProgressIndicator());
                        }),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.teal,
                        size: 10,
                      ),
                      Text(
                        "Concentric Trend",
                        style: TextStyle(color: Colors.teal),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 10,
                      ),
                      Text(
                        "Eccentric Trend",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder<List<ResultsRepetition>>(
                    future: futureResultsRepetition,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ResultsRepetition> results = snapshot.data!;
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            DataTable(
                                columnSpacing: 30,
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    'Repetition',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Concentric',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Eccentric',
                                    style: TextStyle(color: Colors.white),
                                  ))
                                ],
                                rows: results.map<DataRow>((result) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                        '${result.repetition}',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(Text(
                                        '${result.velocityC} m/s',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(Text(
                                        '${result.velocityE} m/s',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ],
                                  );
                                }).toList()),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Snapshot error ${widget.exerciseId}: ${snapshot.error}');
                      }

                      return Center(child: const CircularProgressIndicator());
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                      child: Text(
                    'Barbell Path',
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  )),
                ),
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 20,
                )),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 28),
                    height: 350,
                    child: FutureBuilder<List<ResultsPath>>(
                        future: futureResultsPath,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<ResultsPath> results = snapshot.data!;
                            List<FlSpot> positionData = results
                                .map((result) =>
                                    FlSpot(result.xPos, result.yPos))
                                .toList();

                            return LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                lineBarsData: [
                                  LineChartBarData(
                                    preventCurveOverShooting: true,
                                    dotData: FlDotData(show: true),
                                    spots: positionData,
                                    isCurved: false,
                                    color: Colors.teal,
                                    barWidth: 4,
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Snapshot error: ${snapshot.error}');
                          }

                          return Center(
                              child: const CircularProgressIndicator());
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
