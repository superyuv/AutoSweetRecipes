import 'package:auto_sweet_recipe/pages/pageRecipeFather.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipeCardData.dart';
import '../services/firebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/pageNameProvider.dart';

class PageRecipeSelection extends StatelessWidget {
  const PageRecipeSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PageNameProvider>(context, listen: false)
          .setPageName("Recipes");
    });
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Search',
      home:
          Directionality(textDirection: TextDirection.rtl, child: recipeSearch()),
    );
  }
}

class recipeSearch extends StatefulWidget {
  const recipeSearch({super.key});

  @override
  State<recipeSearch> createState() => _recipeSearchState();
}

class _recipeSearchState extends State<recipeSearch> {
  FirebaseService firebaseService = FirebaseService();
  _recipeSearchState() {
    setFavorites();
    readUserInventory();
  }

  setFavorites() async {
    firebaseService.readFavoritesOfCurrentUser().then((value) => {
          setState(() {
            _saved = value;
          })
        });
  }

  List<String> userInventory = [];
  readUserInventory() async {
    firebaseService.readInventoryOfCurrentUser().then((value) => {
      setState(() {
        userInventory = value;
      })
    });
  }

  List<RecipeCardData> _suggestions = [];
  List<String> _saved = [];
  final _biggerFont = const TextStyle(fontSize: 18);
  final TextEditingController eCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PageNameProvider>(context, listen: false)
          .setPageName("Recipes");
    });
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firebaseService.readRecipesAsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            _suggestions = snapshot.data!.docs
                .map((e) => RecipeCardData(
                      title: e['recipeName'],
                      imageUrl: e["recipeIcon"],
                      stringList: [
                        (e.data()["ratingAvg"]?.toString() ?? "0"),
                        "Uses: ${e.data()["useCounter"]?.toString() ?? "0"}",
                        "${score(e.data()["ingredients"], userInventory) ?? "0"}",

                      ],
            ))
                .toList();

            _suggestions.sort((a, b) => double.parse(b.stringList![2]).compareTo(double.parse(a.stringList![2])));
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              itemCount: _suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  elevation: 3,
                  child: GestureDetector(
                    onTap: () {
                      firebaseService.addUseCounter(_suggestions[index].title.toString());
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return PageRecipeFather(
                                recipeName: _suggestions[index].title);
                          }));                    },
                    child: Row(
                      children: [
                        RatingBarIndicator(
                          rating: double.parse(_suggestions[index].stringList![0])/1.0 ?? 0.0,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 15.0,
                          direction: Axis.vertical,
                        ),
                        (_suggestions[index].imageUrl != null &&
                                _suggestions[index].imageUrl != "")
                            ? Expanded(
                                flex: 2,
                                child: Image.network(
                                    _suggestions[index].imageUrl ?? ""),
                              )
                            : const SizedBox(width: 90, height: 0),
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _suggestions[index].title ?? "",
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
                                    _suggestions[index].stringList![1] ?? "0",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Score: " +
                                    _suggestions[index].stringList![2] ?? "0",
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
                            //     final alreadySaved = _saved.contains(_suggestions[index]);
                            icon: _saved.contains(_suggestions[index].title)
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                            onPressed: () async {
                              await firebaseService.writeFavoritesOfCurrentUser(
                                  _suggestions[index].title);
                              await setFavorites();
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
        });
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
