import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_planner/recipe_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Recipe {
  String name;
  String img;
  int cals;
  String time;
  Map ing;
  Map steps;
  Recipe(this.name, this.img, this.cals, this.time, this.ing, this.steps);

  factory Recipe.fromJson(Map<dynamic, dynamic> json) {
    final name = json["name"];
    final cals = json["cal"];
    final time = json["time"];
    final ing = {};
    for (int i = 0; i < json["ingredients"].length; i++) {
      ing[i] = json["ingredients"][i];
    }
    final steps = {};
    for (int i = 0; i < json["steps"].length; i++) {
      steps[i] = json["steps"][i];
    }
    final img = json["img"];
    return Recipe(name, img, cals, time, ing, steps);
  }
}

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<Recipe> recipes = [];
  bool isLoaded = false;

  void getData() async {
    recipes.clear();
    DatabaseReference reference =
        FirebaseDatabase().reference().child("Recipes");
    await reference.once().then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        recipes.add(Recipe.fromJson(value));
      });
    });
    if (mounted) {
      setState(() {
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Recipes",
          style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
        ),
      ),
      body: isLoaded
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 6),
                  child: Text(
                    "Try out these recipes",
                    style: GoogleFonts.lato(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                      physics: const BouncingScrollPhysics(),
                      childAspectRatio: 1.5,
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: 12,
                      children: List.generate(recipes.length, (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecipeDetailScreen(
                                          recipe: recipes[index],
                                        )));
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: recipes[index].img,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 160,
                                  errorWidget: (context, url, error) {
                                    return Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 160,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                recipes[index].name,
                                style: GoogleFonts.lato(),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                )
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
