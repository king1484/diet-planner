import 'package:diet_planner/food.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? database;

  openDB() async {
    database ??= await openDatabase(
        join(await getDatabasesPath(), "calories_database9.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE food(id INTEGER PRIMARY KEY, date TEXT, calories INTEGER, breakfast_cals INTEGER, snacks_cals INTEGER, lunch_cals INTEGER, dinner_cals INTEGER, breakFastDone INTEGER, lunchDone INTEGER, dinnerDone INTEGER, water INTEGER, proteins INTEGER, carbs INTEGER, fats INTEGER)");
    }, version: 1);
  }

  insertFood(Food food) async {
    List<Map<String, dynamic>> data = await database!.query("food",
        where: "date = ?",
        whereArgs: [DateTime.now().toString().substring(0, 10)]);

    database!.update(
        "food",
        {
          "date": DateTime.now().toString().substring(0, 10),
          "calories": data[0]["calories"] + food.calories,
          "breakfast_cals": food.foodType == 0
              ? data[0]["breakfast_cals"] + food.calories
              : data[0]["breakfast_cals"],
          "lunch_cals": food.foodType == 1
              ? data[0]["lunch_cals"] + food.calories
              : data[0]["lunch_cals"],
          "snacks_cals": food.foodType == 2
              ? data[0]["snacks_cals"] + food.calories
              : data[0]["snacks_cals"],
          "dinner_cals": food.foodType == 3
              ? data[0]["dinner_cals"] + food.calories
              : data[0]["dinner_cals"],
          "breakFastDone": food.foodType == 0 ? 1 : 0,
          "lunchDone": food.foodType == 1 ? 1 : 0,
          "DinnerDone": food.foodType == 3 ? 1 : 0,
          "fats": data[0]["fats"] + food.fats,
          "carbs": data[0]["carbs"] + food.carbs,
          "proteins": data[0]["proteins"] + food.proteins
        },
        where: "date = ?",
        whereArgs: [DateTime.now().toString().substring(0, 10)]);
  }

  newDate() async {
    List<Map<String, dynamic>> data = await database!.query("food",
        where: "date = ?",
        whereArgs: [DateTime.now().toString().substring(0, 10)]);
    if (data.isEmpty) {
      database!.insert("food", {
        "date": DateTime.now().toString().substring(0, 10),
        "calories": 0,
        "breakfast_cals": 0,
        "lunch_cals": 0,
        "snacks_cals": 0,
        "dinner_cals": 0,
        "breakFastDone": 0,
        "lunchDone": 0,
        "dinnerDone": 0,
        "water": 0,
        "fats": 0,
        "carbs": 0,
        "proteins": 0
      });
    }
  }

  insertWater() async {
    List<Map<String, dynamic>> data = await database!.query("food",
        where: "date = ?",
        whereArgs: [DateTime.now().toString().substring(0, 10)]);
    database!.update("food", {"water": data[0]["water"] + 1});
  }

  Future<List<Map<String, dynamic>>> getData() async {
    List<Map<String, dynamic>> data = await database!.query("food",
        where: "date = ?",
        whereArgs: [DateTime.now().toString().substring(0, 10)]);
    return data;
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    List<Map<String, dynamic>> data = await database!.query(
      "food",
    );
    return data;
  }
}
