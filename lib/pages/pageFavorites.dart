import 'package:auto_sweet_recipe/pages/pageRecipeFather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipeCardData.dart';
import '../services/firebaseService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/pageNameProvider.dart';


class PageFavorites extends StatelessWidget {
  const PageFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PageNameProvider>(context, listen: false)
          .setPageName("Favorites");
    });
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Search',
      home: Directionality(
          textDirection: TextDirection.rtl, child: PageFavoritesStateful()),
    );
  }
}

class PageFavoritesStateful extends StatefulWidget {
  const PageFavoritesStateful({super.key});

  @override
  _PageFavoritesStatefulState createState() => _PageFavoritesStatefulState();
}

class _PageFavoritesStatefulState extends State<PageFavoritesStateful> {
  FirebaseService firebaseService = FirebaseService();
  _PageFavoritesStatefulState() {
    readFavorites().then((value) => {
          setState(() {
            favoriteListTitles = value;
          })
        });
    readUserInventory().then((value) => {
      setState(() {
        userInventory = value;
      })
    });
  }

  var favoriteList = [];
  List<String> favoriteListTitles = [];

  Future<List<String>> readFavorites() async {
    return await firebaseService.readFavoritesOfCurrentUser();
  }

  List<String> userInventory = [];
  Future<List<String>> readUserInventory() async {
    return await firebaseService.readInventoryOfCurrentUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firebaseService.readRecipesAsStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              favoriteList = snapshot.data!.docs
                  .where((e) =>
                  favoriteListTitles.contains(e.data()['recipeName'] ?? ""))
                  .map((e) => RecipeCardData(
                        title: e['recipeName'],
                        imageUrl: e["recipeIcon"],
                        stringList: [
                          (e.data()["ratingAvg"]?.toString() ?? "0"),
                          "Uses: ${e.data()["useCounter"]?.toString() ?? "0"}",
                          "Score: ${score(e.data()["ingredients"], userInventory) ?? "0"}",
                        ],
                      ))
                  .toList();
              favoriteList.sort((a,b) => b.stringList[2].compareTo(a.stringList[2]));

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                itemCount: favoriteList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    elevation: 3,
                    child: GestureDetector(
                      onTap: () {
                        firebaseService.addUseCounter(favoriteList[index].title.toString());
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PageRecipeFather(
                              recipeName: favoriteList[index].title);
                        }));
                      },
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            rating: double.parse(favoriteList[index].stringList![0])/1.0 ?? 0.0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            direction: Axis.vertical,
                          ),
                          (favoriteList[index].imageUrl != null &&
                                  favoriteList[index].imageUrl != "")
                              ? Expanded(
                                  flex: 2,
                                  child: Image.network(
                                      favoriteList[index].imageUrl ?? ""),
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
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      favoriteList[index].title ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      favoriteList[index].stringList![1] ?? "0",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      favoriteList[index].stringList![2] ?? "0",
                                      style: const TextStyle(color: Colors.pink),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.favorite),
                              onPressed: () async {
                                await firebaseService
                                    .writeFavoritesOfCurrentUser(
                                        favoriteList[index].title);
                                favoriteListTitles = await firebaseService
                                    .readFavoritesOfCurrentUser();
                                setState(() {});
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

  String score(ingredients, userInventory) {
    if (ingredients.length == 0){
      return "0.00";
    }
    String ing = "";
    int count = 0;
    for (ing in ingredients){
      if (userInventory.contains(ing)){
        count++;
      }
    }

    return (count/ingredients.length * 100).toStringAsFixed(2);
  }
}
