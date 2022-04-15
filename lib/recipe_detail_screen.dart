import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_planner/recipes_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.recipe.name,
          style: GoogleFonts.lato(fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.recipe.img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorWidget: (context, url, error) {
                    return Image.network(
                      url,
                      width: double.infinity,
                      height: 220,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Text(
                widget.recipe.name,
                style:
                    GoogleFonts.lato(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 1),
                              color: Colors.grey.shade200,
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/calories.png",
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.recipe.cals.toString() + " Cals",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 1),
                              color: Colors.grey.shade200,
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/time.png",
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.recipe.time.toString(),
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 16),
              child: Text(
                "Ingredients",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontSize: 16),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 6, left: 16),
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.recipe.ing.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.grey,
                                  size: 10,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  widget.recipe.ing[index],
                                  style: GoogleFonts.lato(fontSize: 14.5),
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16),
              child: Text(
                "Steps",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontSize: 16),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 6, left: 16),
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.recipe.steps.length,
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (index + 1).toString() + ".",
                                style: GoogleFonts.lato(fontSize: 14.5),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12, bottom: 2),
                                  child: Text(
                                    widget.recipe.steps[index],
                                    style: GoogleFonts.lato(fontSize: 14.5),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
