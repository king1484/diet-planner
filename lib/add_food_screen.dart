import 'dart:convert';
import 'dart:io';

import 'package:diet_planner/food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';

class Item {
  String name;
  String servingUnit;
  Item(this.name, this.servingUnit);
}

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>
    with SingleTickerProviderStateMixin {
  List<Item> data = [];
  TextEditingController controller = TextEditingController();
  bool loaded = true;
  final ImagePicker picker = ImagePicker();
  late TabController tabController;
  int tabValue = 0;

  Future getData() async {
    if (controller.text.isNotEmpty) {
      setState(() {
        loaded = false;
      });
      data.clear();
      var json = "";

      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (preferences.containsKey(controller.text.toLowerCase() + "_info")) {
        json = preferences.getString(controller.text.toLowerCase()) ?? "";
      } else {
        var res = await http.get(
            Uri.parse(
                "https://trackapi.nutritionix.com/v2/search/instant?query=" +
                    controller.text.toLowerCase()),
            headers: {
              "x-app-id": "fc272f74",
              "x-app-key": "8beaff593a8307b5f28871d35f823711"
            });
        json = res.body;
        await preferences.setString(controller.text.toLowerCase(), json);
      }
      var decoded = await jsonDecode(json);
      for (var element in decoded["common"]) {
        data.add(Item(toBeginningOfSentenceCase(element["food_name"])!,
            toBeginningOfSentenceCase(element["serving_unit"])!));
      }
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  detectFood() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imagePath = File(image.path);
      setState(() {
        tabValue = 0;
      });
      tabController.animateTo(0);

      await Tflite.loadModel(
          model: "assets/food_model.tflite", labels: "assets/food_labels.txt");
      var preds = await Tflite.runModelOnImage(
          path: imagePath.path,
          threshold: 0.5,
          imageMean: 127.5,
          imageStd: 127.5);
      String text = "";
      for (var ele in preds!) {
        text = ele["label"].toString().substring(3).toLowerCase();
      }
      controller.text = text;
      await getData();
      for (var element in data) {
        if (element.name.toLowerCase() == text ||
            element.name.toLowerCase().contains(text)) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FoodDetailScreen(
                        name: element.name,
                        servingUnit: element.servingUnit,
                      )));
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          "Add Food",
          style: GoogleFonts.lato(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 8, left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                                getData();
                              },
                              textInputAction: TextInputAction.search,
                              style: GoogleFonts.lato(color: Colors.grey[800]),
                              cursorColor: Colors.grey[800],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter food name",
                                hintStyle:
                                    GoogleFonts.lato(color: Colors.grey[800]),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                getData();
                              },
                              child: Container(
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.search),
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[400]),
                              ))
                        ],
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  DefaultTabController(
                      length: 2,
                      child: TabBar(
                        controller: tabController,
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Search",
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Search By AI",
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w800),
                            ),
                          )
                        ],
                        indicatorColor: Colors.white,
                        onTap: (val) {
                          setState(() {
                            tabValue = val;
                          });
                        },
                      ))
                ],
              ),
            ),
          ),
          tabValue == 1
              ? Expanded(
                  child: Column(
                    children: [
                      const Spacer(),
                      Image.asset(
                        "assets/scan.png",
                        height: 70,
                        width: 70,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          detectFood();
                        },
                        fillColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "Detect Food",
                          style: GoogleFonts.lato(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Text(
                          "Take a snap of food you have ate and our AI will automatically detect it",
                          style: GoogleFonts.lato(color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Spacer()
                    ],
                  ),
                )
              : Expanded(
                  child: loaded
                      ? ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FoodDetailScreen(
                                              name: data[index].name,
                                              servingUnit:
                                                  data[index].servingUnit,
                                            )));
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 14),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.breakfast_dining,
                                            color: Colors.purple,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(data[index].name,
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              Text(data[index].servingUnit,
                                                  style: GoogleFonts.lato(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[300]),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(Icons.add),
                                              )),
                                          const SizedBox(
                                            width: 6,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        height: 2,
                                      )
                                    ],
                                  )),
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.blue[300],
                          ),
                        ))
        ],
      ),
    );
  }
}
