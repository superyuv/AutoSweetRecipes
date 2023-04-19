import '../models/recipeModel.dart';
import '../services/firebaseService.dart';

class RecipeFactory {

  FirebaseService firebaseService = FirebaseService();

  dynamic modified_recipe(String type, RecipeModel recipe) {
    print(recipe.ingredients);
    for (int i = 0; i < recipe.ingredients.length; i++) {
      recipe.ingredients[i] =
          firebaseService.checkSubstitute(type, recipe.ingredients[i]);
    }
    print(recipe.ingredients);
  }
}
