import 'package:flutter/material.dart';
import '../models/recipeModel.dart';
import '../services/firebaseService.dart';

class PageEditRecipe extends StatefulWidget {
  final RecipeModel recipe;

  const PageEditRecipe({Key? key, required this.recipe}) : super(key: key);
  @override
  State<PageEditRecipe> createState() => _PageEditRecipeState();
}

class _PageEditRecipeState extends State<PageEditRecipe> {
  _PageEditRecipeState() {}
  FirebaseService firebaseService = FirebaseService();

  // Text Controllers
  TextEditingController recipeNameController = TextEditingController();
  TextEditingController inventoryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController iconController = TextEditingController();
  TextEditingController prepTimeController = TextEditingController();


  // Variables
  bool editDisable = true;
  Color textEnableColor = Colors.black12;
  List<dynamic> ingredients = [];


  @override
  Widget build(BuildContext context) {
    // Setting data to recipe data
    recipeNameController.text = widget.recipe.recipeName;
    String title = widget.recipe.recipeName;
    descriptionController.text = widget.recipe.recipeDescription;
    iconController.text = widget.recipe.recipeIcon;
    instructionsController.text = widget.recipe.instructions;
    ingredients = widget.recipe.ingredients;
    prepTimeController.text = widget.recipe.prepTime.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(title), //Changes to recipe name
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        shrinkWrap: true,
        children: [

          const Text('Recipe Name:',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,),
            textScaleFactor: 1.6,),

          TextFormField(
            onChanged: (value) {
              setState(() {
                title = recipeNameController.text;
              });
            },
            enabled: !editDisable,
            controller: recipeNameController,
            expands: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),

          const Text('Description:',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,),
            textScaleFactor: 1.6,),

          TextFormField(
            minLines: 3,
            maxLines: 5,
            enabled: editDisable,
            controller: descriptionController,
            expands: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                )
            ),
          ),

          const Text('Instructions:',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,),
            textScaleFactor: 1.6,
          ),

          TextFormField(
            minLines: 3,
            maxLines: 5,
            enabled: editDisable,
            controller: instructionsController,
            expands: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))
            ),
          ),

          const Text('Recipe Icon:',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,),
            textScaleFactor: 1.6,
          ),

          TextFormField(
            minLines: 1,
            maxLines: 3,
            enabled: editDisable,
            controller: iconController,
            expands: false,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))
            ),
          ),

          Row(
              children: [
                const Text('Prep Time(mins):',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w900,
                    decoration: TextDecoration.underline,),
                  textScaleFactor: 1.6,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                  child: SizedBox(
                      width: 70,
                      height: 80,
                      child: TextFormField(
                        enabled: editDisable,
                        controller: prepTimeController,
                        maxLength: 4,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0))
                        ),
                      )
                  ),
                ),

              ]
          ),

          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: inventoryController,),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: SizedBox(
                        width: 40,
                        child: FloatingActionButton(
                          heroTag: 3,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15.0))),
                          onPressed: () async {
                            if (inventoryController.text.trim() != "" && !ingredients.contains(inventoryController.text.trim())) {
                              ingredients.add(inventoryController.text
                                  .toLowerCase());
                              inventoryController.text = '';
                              setState(() {});
                            }else{
                              inventoryController.text = '';
                            }
                          },
                          foregroundColor: Colors.black,
                          child: const Text("+", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                              textScaleFactor: 2.7),
                        ),
                      )
                  ),
                  SizedBox(
                    width: 40,
                    child: FloatingActionButton(
                      heroTag: 4,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.0))),
                      onPressed: () async {
                        if (inventoryController.text.trim() != "") {
                          ingredients.remove(
                              inventoryController.text.toLowerCase());
                          inventoryController.text = '';
                          setState(() {});
                        }
                      },
                      foregroundColor: Colors.black,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 100,
              height: 30,
              child: FloatingActionButton(
                heroTag: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(
                        10.0))),
                onPressed: () async {
                  inventoryController.text = "";
                  setState(() {});
                },
                // backgroundColor: const Color(0x818170bb),
                foregroundColor: Colors.black,
                child: const Text("Clear text", style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800),),
              ),
            ),
          ),

          const Text('Ingredients',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,),
            textScaleFactor: 1.6,),

          ListView.builder(
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    elevation: 3,
                    child: GestureDetector(
                        onTap: () {
                          inventoryController.text = ingredients[index];
                        },
                        child: Text(ingredients[index].toString())
                    )
                );
              }
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              heroTag: 6,
              onPressed: () async {
                if (await checkData()) {
                  firebaseService.updateRecipe(
                      recipeNameController.text,
                      descriptionController.text,
                      instructionsController.text,
                      iconController.text,
                      int.parse(prepTimeController.text),
                      ingredients,
                      );
                  Navigator.pop(context);
                }
              },
              backgroundColor: Colors.pink,
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }

  Future <bool> checkData() async {
    if (ingredients == []) {
      _illegalData(context, "Missing recipe ingredients");
      return false;
    }
    if (descriptionController.text == '') {
      _illegalData(context, "Missing recipe description");
      return false;
    }
    if (instructionsController.text == '') {
      _illegalData(context, "Missing recipe instructions");
      return false;
    }

    if (iconController.text == '') {
      _illegalData(context, "Missing recipe icon");
      return false;
    }

    if (prepTimeController.text == '' || int.parse(prepTimeController.text) <= 0) {
      _illegalData(context, "Missing recipe prep time");
      return false;
    }
    return true;
  }

  //Missing data popup
  Future <void> _illegalData(BuildContext context, String error) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              "Problem with data!", textAlign: TextAlign.left),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}