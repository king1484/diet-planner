import 'package:diet_planner/add_food_screen.dart';
import 'package:diet_planner/database_helper.dart';
import 'package:diet_planner/profile_screen.dart';
import 'package:diet_planner/recipes_screen.dart';
import 'package:diet_planner/water_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeNavigationScreen extends StatefulWidget {
  const HomeNavigationScreen({Key? key}) : super(key: key);

  @override
  _HomeNavigationScreenState createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  int bottomBarIndex = 0;
  List<Widget> widgets = const [HomeScreen(), RecipesScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          setState(() {
            bottomBarIndex = i;
          });
        },
        currentIndex: bottomBarIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.dining), label: "Recepies"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: widgets[bottomBarIndex],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int consumedCals = 0;
  static int proteinsGrams = 0;
  static int carbsGrams = 0;
  static int fatsGrams = 0;
  static int proteinsGramsTotal = 500;
  static int carbsGramsTotal = 500;
  static int fatsGramsTotal = 500;
  static int calories = 10000;
  static int breakfastCals = 0;
  static int lunchCals = 0;
  static int snacksCals = 0;
  static int dinnerCals = 0;
  static String name = "";
  static int water = 0;
  bool isLoaded = false;

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      calories = preferences.getInt("c2") ?? 0;
      proteinsGramsTotal = preferences.getInt("proteins") ?? 0;
      carbsGramsTotal = preferences.getInt("carbs") ?? 0;
      fatsGramsTotal = preferences.getInt("fats") ?? 0;
      name = preferences.getString("name") ?? "";
    });
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.openDB();
    await databaseHelper.newDate();
    List<Map<String, dynamic>> data = await databaseHelper.getData();

    if (mounted) {
      setState(() {
        consumedCals = data[0]["calories"];
        proteinsGrams = data[0]["proteins"];
        carbsGrams = data[0]["carbs"];
        fatsGrams = data[0]["fats"];
        breakfastCals = data[0]["breakfast_cals"];
        lunchCals = data[0]["lunch_cals"];
        snacksCals = data[0]["snacks_cals"];
        dinnerCals = data[0]["dinner_cals"];
        water = data[0]["water"];
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.4, color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 1),
                        color: Colors.grey.shade200,
                        blurRadius: 2)
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white),
              child: Text(
                "Today",
                style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        onTap: () {
                          Share.share(
                              "Download the Smart Food Diet Planner app from the link below and maintain a good health by using this app.\nLink - https://play.google.com/store/apps/details?id=com.techvinay.diet_planner");
                        },
                        child: Text(
                          "Share App",
                          style: GoogleFonts.lato(),
                        )),
                    PopupMenuItem(
                        onTap: () async {
                          await canLaunch("https://www.instagram.com/vinni1484/")
                              ? await launch("https://www.instagram.com/vinni1484/")
                              : debugPrint("Cant launch");
                        },
                        child: Text(
                          "Follow Us",
                          style: GoogleFonts.lato(),
                        )),
                  ];
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFoodScreen())).then((value) {
            getData();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: isLoaded
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                  child: Container(
                      padding: const EdgeInsets.only(top: 14),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 5),
                            child: Text(
                              "Welcome, " + name,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: CircularPercentIndicator(
                              backgroundColor: Colors.white54.withOpacity(0.4),
                              radius: 130,
                              animation: true,
                              progressColor: Colors.white,
                              percent: consumedCals >= calories
                                  ? 1.0
                                  : consumedCals / calories,
                              lineWidth: 9,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: consumedCals < calories
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (calories - consumedCals).toString(),
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Cals Remaining",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.done,
                                          size: 26,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "0 cals remaining",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "Goal acheived",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Consumed",
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(consumedCals.toString() + " Cals",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(calories.toString() + " Cals",
                                          style: GoogleFonts.lato(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )),
                ),
                const SizedBox(
                  height: 6,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 1),
                                      color: Colors.grey.shade400,
                                      blurRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, bottom: 10),
                                  child: Text(
                                    "Todays Consumption",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey[800],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text("Proteins",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey[800],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              proteinsGrams.toString() +
                                                  "/" +
                                                  proteinsGramsTotal
                                                      .toString() +
                                                  " g",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          LinearPercentIndicator(
                                            width: 65,
                                            lineHeight: 10,
                                            progressColor: Colors.blue,
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            percent: proteinsGrams >
                                                    proteinsGramsTotal
                                                ? 1.0
                                                : proteinsGrams /
                                                    proteinsGramsTotal,
                                          )
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
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              carbsGrams.toString() +
                                                  "/" +
                                                  carbsGramsTotal.toString() +
                                                  " g",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          LinearPercentIndicator(
                                            width: 65,
                                            lineHeight: 10,
                                            progressColor: Colors.blue,
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            percent: carbsGrams >
                                                    carbsGramsTotal
                                                ? 1.0
                                                : carbsGrams / carbsGramsTotal,
                                          )
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
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              fatsGrams.toString() +
                                                  "/" +
                                                  fatsGramsTotal.toString() +
                                                  " g",
                                              style: GoogleFonts.lato(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          LinearPercentIndicator(
                                            width: 65,
                                            lineHeight: 10,
                                            progressColor: Colors.blue,
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            percent: fatsGrams > fatsGramsTotal
                                                ? 1.0
                                                : fatsGrams / fatsGramsTotal,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WaterScreen())).then((value) {
                                  getData();
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 1),
                                          color: Colors.grey.shade400,
                                          blurRadius: 2)
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/water.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Water",
                                            style: GoogleFonts.lato(
                                                color: Colors.grey[800],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const WaterScreen()))
                                                  .then((value) {
                                                getData();
                                              });
                                            },
                                            child: Text(
                                              "ADD",
                                              style: GoogleFonts.lato(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 4),
                                      child: Text(
                                        "Take a glass of water",
                                        style: GoogleFonts.lato(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 5),
                                      child: Text(
                                        "Drank " +
                                            water.toString() +
                                            " glasses",
                                        style: GoogleFonts.lato(
                                            color: Colors.grey[500],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddFoodScreen())).then((value) {
                                getData();
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 1),
                                        color: Colors.grey.shade400,
                                        blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/breakfast.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Breakfast",
                                          style: GoogleFonts.lato(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AddFoodScreen()))
                                                .then((value) {
                                              getData();
                                            });
                                          },
                                          child: Text(
                                            "ADD",
                                            style: GoogleFonts.lato(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 4),
                                    child: Text(
                                      "300 - 400 Cals recommended",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text(
                                        "Consumed " +
                                            breakfastCals.toString() +
                                            " Cals",
                                        style: GoogleFonts.lato(
                                            color: Colors.grey[500],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddFoodScreen())).then((value) {
                                getData();
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 1),
                                        color: Colors.grey.shade400,
                                        blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/lunch.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Lunch",
                                          style: GoogleFonts.lato(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AddFoodScreen()))
                                                .then((value) {
                                              getData();
                                            });
                                          },
                                          child: Text(
                                            "ADD",
                                            style: GoogleFonts.lato(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 4),
                                    child: Text(
                                      "500 - 600 Cals recommended",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text(
                                      "Consumed " +
                                          lunchCals.toString() +
                                          " Cals",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddFoodScreen())).then((value) {
                                getData();
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 1),
                                        color: Colors.grey.shade400,
                                        blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/snacks.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Snacks",
                                          style: GoogleFonts.lato(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AddFoodScreen()))
                                                .then((value) {
                                              getData();
                                            });
                                          },
                                          child: Text(
                                            "ADD",
                                            style: GoogleFonts.lato(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 4),
                                    child: Text(
                                      "100 - 200 Cals recommended",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text(
                                      "Consumed " +
                                          snacksCals.toString() +
                                          " Cals",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10, bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddFoodScreen())).then((value) {
                                getData();
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 1),
                                        color: Colors.grey.shade400,
                                        blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/dinner.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Dinner",
                                          style: GoogleFonts.lato(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AddFoodScreen()))
                                                .then((value) {
                                              getData();
                                            });
                                          },
                                          child: Text(
                                            "ADD",
                                            style: GoogleFonts.lato(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 4),
                                    child: Text(
                                      "500 - 600 Cals recommended",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text(
                                      "Consumed " +
                                          dinnerCals.toString() +
                                          " Cals",
                                      style: GoogleFonts.lato(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
