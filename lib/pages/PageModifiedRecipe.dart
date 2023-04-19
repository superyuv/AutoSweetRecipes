import 'package:auto_sweet_recipe/models/recipeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_sweet_recipe/pages/pageRecipeFather.dart';
import 'package:flutter/material.dart';


class PageModifiedRecipe extends StatelessWidget {
  final RecipeModel recipe;
  const PageModifiedRecipe({Key? key, required this.recipe}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String RECIPE_NAME = recipe.recipeName ?? "";
    String DESCRIPTIONS = recipe.recipeDescription ?? "";
    String RECIPE_ICON = recipe.recipeIcon ?? "";
    String INSTRUCTIONS = recipe.instructions ?? "";
    List INGREDIENTS = recipe.ingredients ?? [];
    int PREP_TIME = recipe.prepTime ?? 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(RECIPE_NAME + " " + TYPE),
          centerTitle: true,
          toolbarHeight: 30.2,
          backgroundColor: const Color.fromRGBO(232, 115, 164, 1.0)
      ),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          shrinkWrap: true,
          children: [
            Container(
                padding:const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Image.network(RECIPE_ICON, width:100, height: 250)
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

          ]
      ),
    );
  }
}
