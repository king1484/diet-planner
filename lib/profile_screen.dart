import 'package:charts_flutter/flutter.dart' as charts;
import 'package:diet_planner/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  DateTime dateTime;
  int calories;
  int proteins;
  int carbs;
  int fats;
  Data(this.dateTime, this.calories, this.proteins, this.carbs, this.fats);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static int calories = 0;
  static int proteins = 0;
  static int carbs = 0;
  static int fats = 0;
  static String name = "";
  List<charts.Series<Data, DateTime>> series = [];
  String text = "";
  DateTime? date;
  bool isSelected = false;
  DateFormat format = DateFormat("dd MMM");
  Map<String, double> pieData = {};
  List<Data> d = [];
  bool isLoaded = false;

  getData() async {
    DateTime now = DateTime.parse(DateTime.now().toString().substring(0, 10));
    d.clear();
    d = [
      Data(now, 0, 0, 0, 0),
      Data(now.subtract(const Duration(days: 1)), 0, 0, 0, 0),
      Data(now.subtract(const Duration(days: 2)), 0, 0, 0, 0),
      Data(now.subtract(const Duration(days: 3)), 0, 0, 0, 0),
      Data(now.subtract(const Duration(days: 4)), 0, 0, 0, 0),
      Data(now.subtract(const Duration(days: 5)), 0, 0, 0, 0),
      Data(now.subtract(const Duration(days: 6)), 0, 0, 0, 0)
    ];
    series.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    proteins = preferences.getInt("proteins") ?? 0;
    carbs = preferences.getInt("carbs") ?? 0;
    fats = preferences.getInt("fats") ?? 0;
    setState(() {
      calories = preferences.getInt("c2") ?? 0;
      name = preferences.getString("name") ?? "";
    });
    DatabaseHelper helper = DatabaseHelper();
    await helper.openDB();
    List<Map<String, dynamic>> data = await helper.getAllData();
    List<Map<String, dynamic>> data1 = await helper.getData();
    for (var element in data) {
      for (var e in d) {
        if (e.dateTime == DateTime.parse(element["date"])) {
          e.calories = element["calories"];
          e.proteins = element["proteins"];
          e.carbs = element["carbs"];
          e.fats = element["fats"];
        }
      }
    }
    if (mounted) {
      setState(() {
        pieData["Proteins"] = data1[0]["proteins"].toDouble();
        pieData["Carbs"] = data1[0]["carbs"].toDouble();
        pieData["Fats"] = data1[0]["fats"].toDouble();
      });
    }

    if (mounted) {
      setState(() {
        series.add(charts.Series(
          data: d,
          id: "Data",
          domainFn: (datum, index) => datum.dateTime,
          measureFn: (datum, index) => datum.calories,
          labelAccessorFn: (datum, index) => datum.calories.toString(),
        ));
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Profile",
            style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
          ),
        ),
        body: isLoaded
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Hello, " + name,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 1),
                                  color: Colors.grey.shade100,
                                  blurRadius: 2)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "Daily calories goal - " +
                              calories.toString() +
                              " Cals",
                          style: GoogleFonts.lato(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Weekly Calories Consumption",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width / 1.7,
                        width: MediaQuery.of(context).size.width - 30,
                        child: charts.TimeSeriesChart(
                          series,
                          animate: true,
                          behaviors: [
                            charts.LinePointHighlighter(
                                symbolRenderer: charts.CircleSymbolRenderer())
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig(
                                changedListener: (charts.SelectionModel model) {
                              if (model.hasDatumSelection) {
                                setState(() {
                                  isSelected = true;
                                  text = model.selectedSeries[0]
                                      .measureFn(model.selectedDatum[0].index)
                                      .toString();
                                  date = model.selectedSeries[0]
                                      .domainFn(model.selectedDatum[0].index);
                                });
                              }
                            })
                          ],
                          domainAxis: const charts.DateTimeAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  minimumPaddingBetweenLabelsPx: 0),
                              tickFormatterSpec:
                                  charts.AutoDateTimeTickFormatterSpec(
                                day: charts.TimeFormatterSpec(
                                  format: 'dd',
                                  transitionFormat: 'dd MMM',
                                ),
                              )),
                          defaultRenderer:
                              charts.LineRendererConfig(includePoints: true),
                        ),
                      ),
                    ),
                    isSelected
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                "Consumed " +
                                    text +
                                    " Cals on " +
                                    format.format(date!),
                                style: GoogleFonts.lato(fontSize: 12),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 16),
                      child: Text(
                        "Todays Nutrients Consumption",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    pieData.isEmpty
                        ? Container()
                        : SizedBox(
                            height: MediaQuery.of(context).size.width / 1.7,
                            width: MediaQuery.of(context).size.width - 30,
                            child: PieChart(
                                dataMap: pieData,
                                colorList: const [
                                  Colors.green,
                                  Color(0xffff6e40),
                                  Color(0xff408ec6),
                                ],
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                chartLegendSpacing: 30,
                                chartValuesOptions: const ChartValuesOptions(
                                    showChartValuesInPercentage: true,
                                    chartValueStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                    chartValueBackgroundColor:
                                        Colors.transparent),
                                legendOptions: LegendOptions(
                                    legendTextStyle: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                                chartRadius:
                                    MediaQuery.of(context).size.width / 2.2)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Weekly Nutrition Timeline",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    DayWidget(
                        d: d,
                        index: 0,
                        calories: calories,
                        proteins: proteins,
                        carbs: carbs,
                        fats: fats),
                    DayWidget(
                        d: d,
                        index: 1,
                        calories: calories,
                        proteins: proteins,
                        carbs: carbs,
                        fats: fats),
                    DayWidget(
                        d: d,
                        index: 2,
                        calories: calories,
                        proteins: proteins,
                        carbs: carbs,
                        fats: fats),
                    DayWidget(
                        d: d,
                        index: 3,
                        calories: calories,
                        proteins: proteins,
                        carbs: carbs,
                        fats: fats),
                    DayWidget(
                        d: d,
                        index: 4,
                        calories: calories,
                        proteins: proteins,
                        carbs: carbs,
                        fats: fats),
                    DayWidget(
                        d: d,
                        index: 5,
                        calories: calories,
                        proteins: proteins,
                        carbs: carbs,
                        fats: fats),
                    DayWidget(
                        d: d,
                        index: 6,
                        calories: calories,
                        proteins: proteins,
                        carbs: carbs,
                        fats: fats),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class DayWidget extends StatelessWidget {
  const DayWidget({
    Key? key,
    required this.d,
    required this.index,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  }) : super(key: key);

  final List<Data> d;
  final int calories;
  final int proteins;
  final int carbs;
  final int fats;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: const Offset(0, 1),
              color: Colors.grey.shade300,
              blurRadius: 2)
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                index == 0
                    ? "Today"
                    : index == 1
                        ? "Yesterday"
                        : DateFormat("dd MMM yyyy").format(d[index].dateTime),
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            d[index].calories != 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 6),
                        child: Text(
                          "Calories",
                          style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 6),
                            child: LinearPercentIndicator(
                              width: 80,
                              lineHeight: 10,
                              animation: true,
                              progressColor: const Color(0xffff6e40),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              percent: d[index].calories >= calories
                                  ? 1
                                  : d[index].calories / calories,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, top: 6),
                            child: Text(
                              d[index].calories.toString() + " Cals",
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 6),
                        child: Text(
                          "Nutrients",
                          style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  "Proteins",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  d[index].proteins.toString() +
                                      "/" +
                                      proteins.toString() +
                                      " g",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 60,
                                lineHeight: 10,
                                animation: true,
                                progressColor: Colors.blue,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                percent: d[index].proteins >= proteins
                                    ? 1
                                    : d[index].proteins / proteins,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  "Carbs",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  d[index].carbs.toString() +
                                      "/" +
                                      carbs.toString() +
                                      " g",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 60,
                                lineHeight: 10,
                                animation: true,
                                progressColor: Colors.blue,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                percent: d[index].carbs >= carbs
                                    ? 1
                                    : d[index].carbs / carbs,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  "Fats",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  d[index].fats.toString() +
                                      "/" +
                                      fats.toString() +
                                      " g",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              LinearPercentIndicator(
                                width: 60,
                                lineHeight: 10,
                                animation: true,
                                progressColor: Colors.blue,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                percent: d[index].fats >= fats
                                    ? 1
                                    : d[index].fats / fats,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                    "No food taken",
                    style: GoogleFonts.lato(),
                  )),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
