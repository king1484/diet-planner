import 'package:diet_planner/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({Key? key}) : super(key: key);

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  int water = 0;
  bool isOn = true;

  getData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.openDB();
    List<Map<String, dynamic>> data = await databaseHelper.getData();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      water = data[0]["water"];
      isOn = preferences.getBool("waterOn") ?? true;
    });
  }

  addData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.openDB();
    await databaseHelper.insertWater();
    getData();
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
          "Water",
          style: GoogleFonts.lato(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Smart Water Remainder",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              const SizedBox(
                width: 4,
              ),
              Switch(
                  value: isOn,
                  onChanged: (val) async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.setBool("waterOn", val);
                    setState(() {
                      isOn = val;
                    });
                  })
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[300]),
              child: Text(
                "Smart remainder will remind you to drink water every hour until you drink 10 glasses of water daily",
                style: GoogleFonts.lato(color: Colors.grey[800]),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 50,
              ),
              InkWell(
                onTap: () {
                  addData();
                },
                child: Image.asset(
                  "assets/waterimg.png",
                  height: 85,
                  width: 100,
                ),
              ),
              InkWell(
                onTap: () {
                  addData();
                },
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.blue),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearPercentIndicator(
                width: 100,
                lineHeight: 12,
                animation: true,
                progressColor: Colors.blue,
                linearStrokeCap: LinearStrokeCap.roundAll,
                percent: water >= 10 ? 1 : water / 10,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            water.toString() + " / 10",
            style: GoogleFonts.lato(),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Drank " + water.toString() + " glasses",
            style: GoogleFonts.lato(fontSize: 16),
          ),
          const SizedBox(
            height: 40,
          ),
          const Spacer()
        ],
      ),
    );
  }
}
