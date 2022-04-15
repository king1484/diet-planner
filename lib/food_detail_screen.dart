import 'dart:convert';

import 'package:diet_planner/database_helper.dart';
import 'package:diet_planner/food.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodDetailScreen extends StatefulWidget {
  final String name;
  final String servingUnit;
  const FoodDetailScreen(
      {Key? key, required this.name, required this.servingUnit})
      : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool breakfast = true;
  bool lunch = false;
  bool snacks = false;
  bool dinner = false;
  bool loaded = false;
  bool success = true;
  Map<String, double> pieData = {};
  var data = {};
  var json = "";
  int status = 0;

  getData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (preferences.containsKey(widget.name.toLowerCase() + "_info")) {
        json = preferences.getString(widget.name.toLowerCase() + "_info") ?? "";
        status = 200;
      } else {
        var res = await http.post(
            Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients"),
            body: {
              "query": widget.name
            },
            headers: {
              "x-app-id": "fc272f74",
              "x-app-key": "8beaff593a8307b5f28871d35f823711"
            });
        json = res.body;
        await preferences.setString(widget.name.toLowerCase() + "_info", json);
        status = res.statusCode;
      }
      data = await jsonDecode(json);
      if (status == 200) {
        pieData["Proteins"] = data["foods"][0]["nf_protein"].toDouble();
        pieData["Carbs"] = data["foods"][0]["nf_total_carbohydrate"].toDouble();
        pieData["Fats"] = data["foods"][0]["nf_total_fat"].toDouble();
        pieData["Sodium"] = data["foods"][0]["nf_sodium"].toDouble();
        pieData["Fiber"] = data["foods"][0]["nf_dietary_fiber"].toDouble();
        setState(() {
          loaded = true;
          success = true;
        });
      } else {
        setState(() {
          loaded = true;
          success = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        loaded = true;
        success = false;
      });
      debugPrint(e.toString());
    }
  }

  addData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.openDB();
    await databaseHelper.insertFood(Food(
        data["foods"][0]["nf_calories"].round(),
        data["foods"][0]["nf_protein"].round(),
        data["foods"][0]["nf_total_carbohydrate"].round(),
        data["foods"][0]["nf_total_fat"].round(),
        breakfast
            ? 0
            : lunch
                ? 1
                : snacks
                    ? 2
                    : 3));
    Fluttertoast.showToast(msg: "Food Added", toastLength: Toast.LENGTH_SHORT);
    Navigator.pop(context);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          widget.name,
          style: GoogleFonts.lato(fontSize: 16),
        ),
      ),
      body: loaded
          ? success
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height / 7,
                          width: double.infinity,
                          color: Colors.blue,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.breakfast_dining,
                                size: 30,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                widget.name,
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Serving Type",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.servingUnit,
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, bottom: 5),
                        child: Text("Nutrients",
                            style: GoogleFonts.lato(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.w900)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12, left: 16, right: 16, bottom: 16),
                        child: PieChart(
                            dataMap: pieData,
                            chartType: ChartType.ring,
                            centerText: data["foods"][0]["nf_calories"]
                                    .round()
                                    .toString() +
                                "\nKcals",
                            centerTextStyle: GoogleFonts.lato(
                                fontSize: 15, color: Colors.grey[800]),
                            colorList: [
                              const Color(0xff408ec6),
                              Colors.purple,
                              const Color(0xffff6e40),
                              Colors.orange.shade300,
                              Colors.green
                            ],
                            ringStrokeWidth: 30,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            chartLegendSpacing: 36,
                            chartValuesOptions: ChartValuesOptions(
                                showChartValuesInPercentage: true,
                                decimalPlaces: 0,
                                chartValueStyle: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                                chartValueBackgroundColor: Colors.transparent),
                            legendOptions: LegendOptions(
                                legendTextStyle: GoogleFonts.lato(
                                    fontWeight: FontWeight.w500, fontSize: 12)),
                            chartRadius: 140),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text("Calories",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    data["foods"][0]["nf_calories"].toString() +
                                        " kcal",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text("Proteins",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    data["foods"][0]["nf_protein"].toString() +
                                        " g",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text("Carbs",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    data["foods"][0]["nf_total_carbohydrate"]
                                            .toString() +
                                        " g",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text("Fats",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    data["foods"][0]["nf_total_fat"]
                                            .toString() +
                                        " g",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 16, bottom: 5),
                        child: Text("Meal Type",
                            style: GoogleFonts.lato(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ChoiceChip(
                            label: Text(
                              "Breakfast",
                              style: GoogleFonts.lato(),
                            ),
                            selected: breakfast,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            selectedColor: const Color(0xff16acea),
                            labelStyle: TextStyle(
                                color:
                                    !breakfast ? Colors.black : Colors.white),
                            onSelected: (value) {
                              setState(() {
                                breakfast = true;
                                lunch = false;
                                snacks = false;
                                dinner = false;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              "Lunch",
                              style: GoogleFonts.lato(),
                            ),
                            selected: lunch,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            selectedColor: const Color(0xff16acea),
                            labelStyle: TextStyle(
                                color: !lunch ? Colors.black : Colors.white),
                            onSelected: (value) {
                              setState(() {
                                lunch = true;
                                breakfast = false;
                                snacks = false;
                                dinner = false;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              "Snacks",
                              style: GoogleFonts.lato(),
                            ),
                            selected: snacks,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            selectedColor: const Color(0xff16acea),
                            labelStyle: TextStyle(
                                color: !snacks ? Colors.black : Colors.white),
                            onSelected: (value) {
                              setState(() {
                                snacks = true;
                                lunch = false;
                                breakfast = false;
                                dinner = false;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              "Dinner",
                              style: GoogleFonts.lato(),
                            ),
                            selected: dinner,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            selectedColor: const Color(0xff16acea),
                            labelStyle: TextStyle(
                                color: !dinner ? Colors.black : Colors.white),
                            onSelected: (value) {
                              setState(() {
                                dinner = true;
                                lunch = false;
                                snacks = false;
                                breakfast = false;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: SizedBox(
                            width: double.infinity,
                            child: RawMaterialButton(
                              onPressed: () {
                                addData();
                              },
                              fillColor: const Color(0xffd71b3b),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "Add To Diet",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: Text("Other Nutrients",
                            style: GoogleFonts.lato(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Saturated Fat",
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  data["foods"][0]["nf_saturated_fat"]
                                          .toString() +
                                      " g",
                                  style: GoogleFonts.lato(),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cholesterol",
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  data["foods"][0]["nf_cholesterol"]
                                          .toString() +
                                      " mg",
                                  style: GoogleFonts.lato(),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sodium",
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  data["foods"][0]["nf_sodium"].toString() +
                                      " mg",
                                  style: GoogleFonts.lato(),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Dietary Fiber",
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  data["foods"][0]["nf_dietary_fiber"]
                                          .toString() +
                                      " g",
                                  style: GoogleFonts.lato(),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sugars",
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  data["foods"][0]["nf_sugars"].toString() +
                                      " g",
                                  style: GoogleFonts.lato(),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Potassium",
                                  style: GoogleFonts.lato(),
                                ),
                                Text(
                                  data["foods"][0]["nf_potassium"].toString() +
                                      " mg",
                                  style: GoogleFonts.lato(),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Error loading, please try again"),
                    const SizedBox(
                      height: 4,
                    ),
                    Center(
                      child: RawMaterialButton(
                        onPressed: () {
                          getData();
                        },
                        fillColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "Retry",
                          style: GoogleFonts.lato(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                )
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.blue[300],
              ),
            ),
    );
  }
}
