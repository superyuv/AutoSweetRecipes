//Define model item for Firestore sync
import '../services/firebaseService.dart';

class RecipeModel {
  String recipeName;
  final String recipeIcon;
  String recipeDescription;
  String instructions;
  final String owner;
  final double ratingAvg;
  final int ratingCounter;
  final int useCounter;
  final int prepTime;
  final List<dynamic> ingredients;

  RecipeModel(
      {this.recipeName = '',
      required this.recipeIcon,
      required this.recipeDescription,
      required this.instructions,
      required this.owner,
      required this.ratingAvg,
      required this.ratingCounter,
      required this.useCounter,
      required this.prepTime,
      required this.ingredients});

  Map<String, dynamic> toJson() => {
        'recipeName': recipeName,
        'recipeIcon': recipeIcon,
        'recipeDescription': recipeDescription,
        'instructions': instructions,
        'owner': owner,
        'ratingAvg': ratingAvg,
        'ratingCounter': ratingCounter,
        'useCounter': useCounter,
        'prepTime': prepTime,
        'ingredients': ingredients,
      };

  dynamic modifiedRecipe(String type) async {
    FirebaseService firebaseService = FirebaseService();
    String temp = "";

    for (int i = 0; i < ingredients.length; i++){
      temp = ingredients[i];
      ingredients[i] = await firebaseService.checkSubstitute(type, ingredients[i]);

      if (temp.compareTo(ingredients[i]) != 0){
        recipeDescription = recipeDescription.replaceAll(temp, ingredients[i]);
        instructions = instructions.replaceAll(temp, ingredients[i]);

      }
    }
  }

  static RecipeModel fromJson(Map<String, dynamic> json) => RecipeModel(
      recipeName: json['recipeName'],
      recipeIcon: json['recipeIcon'],
      recipeDescription: json['recipeDescription'],
      instructions: json['instructions'],
      owner: json['owner'],
      ratingAvg: json['ratingAvg']/1.0 ?? 0.0,
      ratingCounter: json['ratingCounter'] ?? 0,
      prepTime: json['prepTime'] ?? 0,
      useCounter: json['useCounter'] ?? 0,
      ingredients: json['ingredients'] ?? []);
}
