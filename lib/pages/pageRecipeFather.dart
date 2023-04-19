import 'package:auto_sweet_recipe/pages/pageRatePopUp.dart';
import 'package:flutter/material.dart';
import '../models/recipeModel.dart';
import '../services/firebaseService.dart';
import 'PageModifiedRecipe.dart';


String RECIPE_NAME = "";
String TYPE = "";

class PageRecipeFather extends StatefulWidget {
  final String? recipeName;

  PageRecipeFather({Key? key, this.recipeName}) : super(key: key){
    firebaseService = FirebaseService();
    RECIPE_NAME = recipeName!;
  }

  @override
  State<PageRecipeFather> createState() => _PageRecipeFatherState();
}

class _PageRecipeFatherState extends State<PageRecipeFather> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseService.readRecipeByName(RECIPE_NAME),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Text("Something went wrong");
          } else if(!snapshot.hasData){
            return(const Center(child:CircularProgressIndicator()));

          } else {
            RecipeModel recipe = RecipeModel.fromJson(snapshot.data!.docs.first.data());
            String DESCRIPTIONS = recipe.recipeDescription ?? "";
            String RECIPE_ICON = recipe.recipeIcon ?? "";
            String INSTRUCTIONS = recipe.instructions ?? "";
            List INGREDIENTS = recipe.ingredients ?? [];
            int PREP_TIME = recipe.prepTime ?? 0;

            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  title: Text(RECIPE_NAME.toString()),
                  centerTitle: true,
                  toolbarHeight: 30.2,
                  backgroundColor: Color.fromRGBO(232, 115, 164, 1.0)
              ),
              body: ListView(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  shrinkWrap: true,
                  children: [
                    Container(
                        child: Image.network(RECIPE_ICON, width:100, height: 250),
                        padding:EdgeInsets.fromLTRB(10, 0, 10, 0)
                    ),
                    const Text(""),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 80,
                        height: 40,
                        child:TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(3.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  PageRatePopUp(),
                            );
                          },
                          child: const Text("Rate"),
                        ),
                      ),
                    ),

                    const Text(""),
                    Row(
                        children: [
                          const Text('Preparation Time: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w900,
                              decoration: TextDecoration.underline,),
                            textScaleFactor: 1.6,),

                          Text(PREP_TIME.toString() + " mins",
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.2,),
                        ]
                    ),
                    const Text(""),

                    const Text('Description:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,),
                      textScaleFactor: 1.6,),

                    Text(DESCRIPTIONS,
                      textAlign: TextAlign.left,
                      textScaleFactor: 1.2,),

                    const Text(""),

                    const Text('Instructions:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,),
                      textScaleFactor: 1.6,),

                    Text(INSTRUCTIONS,
                      textAlign: TextAlign.left,
                      textScaleFactor: 1.2,),
                    const Text(""),
                    const Text('Ingredients:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,),
                      textScaleFactor: 1.6,),

                    ListView.builder(
                        shrinkWrap: true,
                        itemCount:INGREDIENTS.length,
                        itemBuilder: (BuildContext context, int index){
                          return Card(
                              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              elevation: 3,
                              child:Text(INGREDIENTS[index].toString())
                          );
                        }
                    ),
                    Row(
                      children: [
                        Container(
                          width: 110,
                          padding: EdgeInsets.fromLTRB(3,0,7,0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(3.0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              TYPE = "vegetarian";
                              await recipe.modifiedRecipe(TYPE);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => PageModifiedRecipe(recipe: recipe)));
                              setState(() {});
                            },
                            child: const Text("Vegiterian"),
                          ),
                        ),
                        Container(
                          width: 110,
                          padding: const EdgeInsets.fromLTRB(3,0,7,0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(3.0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              TYPE = "lactose";
                              await recipe.modifiedRecipe(TYPE);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => PageModifiedRecipe(recipe: recipe)));
                              setState(() {});
                            },
                            child: const Text("Lactose"),
                          ),
                        ),Container(
                          width: 110,
                          padding: EdgeInsets.fromLTRB(3,0,7,0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(3.0),
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              TYPE = "celiac";
                              await recipe.modifiedRecipe(TYPE);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => PageModifiedRecipe(recipe: recipe)));
                              setState(() {});
                            },
                            child: const Text("Celiac"),
                          ),
                        ),
                      ],
                    )
                  ]
              ),
            );
          }
        }
    );
  }
}
