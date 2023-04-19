import 'package:auto_sweet_recipe/pages/pageRecipeFather.dart';
import 'package:auto_sweet_recipe/pages/pageEditRecipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../models/recipeCardData.dart';
import '../models/recipeModel.dart';
import '../services/firebaseService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PageUserRecipes extends StatelessWidget {
  const PageUserRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("My Recipes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29,)),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 0,
      ),
      body: const Directionality(
          textDirection: TextDirection.rtl, child: PageUserRecipesStateful()),
    );
  }
}

class PageUserRecipesStateful extends StatefulWidget {
  const PageUserRecipesStateful({super.key});

  @override
  _PageUserRecipesStatefulState createState() => _PageUserRecipesStatefulState();
}

class _PageUserRecipesStatefulState extends State<PageUserRecipesStateful> {
  FirebaseService firebaseService = FirebaseService();
  _PageUserRecipesStatefulState() {
    readFavorites().then((value) => {
          setState(() {
            myRecipesListTitles = value;
          })
        });
  }

  var myRecipesList = [];
  List<String> myRecipesListTitles = [];

  Future<List<String>> readFavorites() async {
    return await firebaseService.readRecipesOfCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firebaseService.readRecipesAsStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              myRecipesList = snapshot.data!.docs
                  .where((e) =>
                  myRecipesListTitles.contains(e.data()['recipeName'] ?? ""))
                  .map((e) => RecipeCardData(
                        title: e['recipeName'],
                        imageUrl: e["recipeIcon"],
                        stringList: [
                          (e.data()["ratingAvg"]?.toString() ?? "0"),
                          "Uses:  ${e.data()["useCounter"]?.toString() ?? "0"}",
                        ],
                      ))
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                itemCount: myRecipesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    elevation: 3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PageRecipeFather(
                              recipeName: myRecipesList[index].title);
                        }));
                      },
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            rating: double.parse(myRecipesList[index].stringList![0])/1.0 ?? 0.0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            direction: Axis.vertical,
                          ),
                          (myRecipesList[index].imageUrl != null &&
                              myRecipesList[index].imageUrl != "")
                              ? Expanded(
                                  flex: 2,
                                  child: Image.network(
                                      myRecipesList[index].imageUrl ?? ""),
                                )
                              : const SizedBox(width: 90, height: 0),
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      myRecipesList[index].title ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ReadMoreText(
                                      myRecipesList[index].stringList![1] ?? "0",
                                      trimLines: 1,
                                      style: const TextStyle(color: Colors.black),
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'Read more...',
                                      trimExpandedText: 'Less',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final querySnapshot = await firebaseService.readRecipeByName(myRecipesList[index].title);
                                final recipeData = querySnapshot.docs.first.data();
                                final recipe = RecipeModel.fromJson(recipeData);

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return PageEditRecipe(
                                          recipe: recipe);
                                    },
                                    )
                                );
                              }
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                firebaseService.removeRecipeByUser(myRecipesList[index].title);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
