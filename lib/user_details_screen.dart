import 'package:diet_planner/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  static int gender = 0;
  static String name = "";
  static String height = "";
  static String age = "";
  static String weight = "";
  static int activity = 0;
}

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  int currentScreen = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 6,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentScreen == 0 ? Colors.blue : Colors.grey[500]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: 6,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentScreen == 1
                            ? Colors.blue
                            : Colors.grey[500]),
                  ),
                ),
                Container(
                  height: 6,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentScreen == 2 ? Colors.blue : Colors.grey[500]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: 6,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentScreen == 3
                            ? Colors.blue
                            : Colors.grey[500]),
                  ),
                ),
                Container(
                  height: 6,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentScreen == 4 ? Colors.blue : Colors.grey[500]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    height: 6,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentScreen == 5
                            ? Colors.blue
                            : Colors.grey[500]),
                  ),
                ),
              ],
            )),
        body: PageView(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              currentScreen = value;
            });
          },
          children: [
            GenderScreen(
              controller: controller,
            ),
            NameScreen(controller: controller),
            HeightScreen(
              controller: controller,
            ),
            AgeScreen(
              controller: controller,
            ),
            WeightScreen(
              controller: controller,
            ),
            ActivityScreen(
              controller: controller,
            )
          ],
        ));
  }
}

class GenderScreen extends StatefulWidget {
  final PageController controller;
  const GenderScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  bool selected1 = false;
  bool selected2 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              "What's your gender?",
              style: GoogleFonts.lato(
                  color: Colors.grey[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected1 = true;
                selected2 = false;
              });
              Data.gender = 0;
              widget.controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1.5,
                      color: selected1 ? Colors.blue : Colors.grey.shade400)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/male.png",
                    height: 22,
                    width: 22,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Male",
                    style:
                        GoogleFonts.lato(color: Colors.grey[800], fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected2 = true;
                selected1 = false;
              });
              Data.gender = 1;
              widget.controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1.5,
                      color: selected2 ? Colors.blue : Colors.grey.shade400)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/female.png",
                    height: 22,
                    width: 22,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Female",
                    style:
                        GoogleFonts.lato(color: Colors.grey[800], fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: RawMaterialButton(
              onPressed: () {
                if (selected1) {
                  Data.gender = 0;
                } else {
                  Data.gender = 1;
                }
                widget.controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              fillColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Next",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class NameScreen extends StatefulWidget {
  final PageController controller;
  const NameScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            InkWell(
                onTap: () {
                  widget.controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: const Icon(Icons.arrow_back)),
            const Spacer(),
            Text(
              "What's your name?",
              style: GoogleFonts.lato(
                  color: Colors.grey[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 16,
            ),
            const Spacer()
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                    hintText: "Name", border: InputBorder.none),
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: RawMaterialButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Data.name = controller.text.toString();
                  FocusScope.of(context).unfocus();
                  widget.controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                }
              },
              fillColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Next",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class HeightScreen extends StatefulWidget {
  final PageController controller;
  const HeightScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _HeightScreenState createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController feetsController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  String dropDown = "cms";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                    onTap: () {
                      widget.controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: const Icon(Icons.arrow_back)),
                const Spacer(),
                Text(
                  "What's your height?",
                  style: GoogleFonts.lato(
                      color: Colors.grey[900],
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 16,
                ),
                const Spacer()
              ],
            )),
        const Spacer(),
        DropdownButton(
            value: dropDown,
            onChanged: (val) {
              setState(() {
                dropDown = val.toString();
              });
            },
            style: GoogleFonts.lato(color: Colors.black, fontSize: 15),
            items:const [
               DropdownMenuItem(
                child: Text("Feets"),
                value: "feets",
              ),
               DropdownMenuItem(
                child:  Text("Centimeters"),
                value: "cms",
              )
            ]),
        const SizedBox(
          height: 4,
        ),
        dropDown == "cms"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 80,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "cm",
                    style: GoogleFonts.lato(color: Colors.grey[800]),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 70,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: feetsController,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "ft",
                    style: GoogleFonts.lato(color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 50,
                    width: 60,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: inchesController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "in",
                    style: GoogleFonts.lato(color: Colors.grey[800]),
                  )
                ],
              ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: RawMaterialButton(
              onPressed: () {
                if (dropDown == "cms") {
                  Data.height = controller.text.toString();
                } else {
                  Data.height = (int.parse(feetsController.text) * 30.48 +
                          int.parse(inchesController.text) * 2.54)
                      .round()
                      .toString();
                }
                FocusScope.of(context).unfocus();
                widget.controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              fillColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Next",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class AgeScreen extends StatefulWidget {
  final PageController controller;
  const AgeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            InkWell(
                onTap: () {
                  widget.controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: const Icon(Icons.arrow_back)),
            const Spacer(),
            Text(
              "What's your age?",
              style: GoogleFonts.lato(
                  color: Colors.grey[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 16,
            ),
            const Spacer()
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              "yrs",
              style: GoogleFonts.lato(color: Colors.grey[800]),
            )
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: RawMaterialButton(
              onPressed: () {
                Data.age = controller.text.toString();
                FocusScope.of(context).unfocus();
                widget.controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              fillColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Next",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class WeightScreen extends StatefulWidget {
  final PageController controller;
  const WeightScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            InkWell(
                onTap: () {
                  widget.controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: const Icon(Icons.arrow_back)),
            const Spacer(),
            Text(
              "What's your weight?",
              style: GoogleFonts.lato(
                  color: Colors.grey[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 16,
            ),
            const Spacer()
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Text("kgs", style: GoogleFonts.lato(color: Colors.grey[800]))
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: RawMaterialButton(
              onPressed: () {
                Data.weight = controller.text.toString();
                FocusScope.of(context).unfocus();
                widget.controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              fillColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Next",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class ActivityScreen extends StatefulWidget {
  final PageController controller;
  const ActivityScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool selected1 = false;
  bool selected2 = false;
  bool selected3 = false;
  bool selected4 = false;

  storeValue() async {
    double calories = 0;
    double extraCals = 0;
    double proteins = 0;
    double carbs = 0;
    double fats = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    switch (Data.activity) {
      case 0:
        extraCals = 1.2;
        break;
      case 1:
        extraCals = 1.375;
        break;
      case 2:
        extraCals = 1.55;
        break;
      case 3:
        extraCals = 1.725;
        break;
    }
    if (Data.gender == 0) {
      calories = (10 * int.parse(Data.weight)) +
          (6.25 * int.parse(Data.height)) -
          (5 * int.parse(Data.age)) +
          5;
      calories = calories * extraCals;
    } else {
      calories = (10 * int.parse(Data.weight)) +
          (6.25 * int.parse(Data.height)) -
          (5 * int.parse(Data.age)) +
          161;
      calories = calories * extraCals;
    }
    proteins = int.parse((Data.weight)) * 1.4;
    carbs = calories / 5;
    fats = (calories / 100) * 30 / 9;

    await preferences.setInt("c2", calories.round());
    await preferences.setInt("proteins", proteins.round());
    await preferences.setInt("carbs", carbs.round());
    await preferences.setInt("fats", fats.round());
    await preferences.setString("name", toBeginningOfSentenceCase(Data.name)!);
    await preferences.setBool("isNew", false);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const HomeNavigationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            InkWell(
                onTap: () {
                  widget.controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: const Icon(Icons.arrow_back)),
            const Spacer(),
            Text(
              "What's your daily activity type?",
              style: GoogleFonts.lato(
                  color: Colors.grey[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 16,
            ),
            const Spacer()
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected1 = true;
                selected2 = false;
                selected3 = false;
                selected4 = false;
              });
            },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1.5,
                      color: selected1 ? Colors.blue : Colors.grey.shade400)),
              child: Center(
                child: Text(
                  "No exercise",
                  style:
                      GoogleFonts.lato(color: Colors.grey[800], fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected1 = false;
                selected2 = true;
                selected3 = false;
                selected4 = false;
              });
            },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1.5,
                      color: selected2 ? Colors.blue : Colors.grey.shade400)),
              child: Center(
                child: Text(
                  "Little exercise",
                  style:
                      GoogleFonts.lato(color: Colors.grey[800], fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected1 = false;
                selected2 = false;
                selected3 = true;
                selected4 = false;
              });
            },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1.5,
                      color: selected3 ? Colors.blue : Colors.grey.shade400)),
              child: Center(
                child: Text(
                  "Medium exercise",
                  style:
                      GoogleFonts.lato(color: Colors.grey[800], fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected1 = false;
                selected2 = false;
                selected3 = false;
                selected4 = true;
              });
            },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 1.5,
                      color: selected4 ? Colors.blue : Colors.grey.shade400)),
              child: Center(
                child: Text(
                  "High exercise",
                  style: TextStyle(color: Colors.grey[800], fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: RawMaterialButton(
              onPressed: () {
                if (selected1) {
                  Data.activity = 0;
                } else if (selected2) {
                  Data.activity = 1;
                } else if (selected3) {
                  Data.activity = 2;
                } else {
                  Data.activity = 3;
                }
                storeValue();
              },
              fillColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Next",
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
