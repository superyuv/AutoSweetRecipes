import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/substituteModel.dart';
import 'authService.dart';


class FirebaseService {
  // Init
  static DocumentReference<Map<String, dynamic>>? docRecipe;
  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp();
  }

  FirebaseService() {
    initialize();
  }

  // Get user email through google login service
  String getCurrentUserEmail() {
    return AuthService.currentUserEmail ?? "test@autosweetrecipe.com";
  }

  // Creating user in DB
  Future<void> writeUserToDB() async {
    String currentEmail = getCurrentUserEmail();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    if (user.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('users').add({
        "userEmail": currentEmail,
        "userName": "John Doe",
        "userPhone": "1234567890",
        "userInventory": [],
        "favorites": [],
      });
    }
  }

  // Get user details from DB
  Future<QuerySnapshot<Map<String, dynamic>>> getUserDetails() {
    String currentEmail = getCurrentUserEmail();
    return FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
  }


  // Get user details from DB as stream
  Stream<QuerySnapshot<Map<String, dynamic>>> readUserAsStream() {
    String currentEmail = getCurrentUserEmail();
    return FirebaseFirestore.instance.collection('users').where(
        'userEmail', isEqualTo: currentEmail).snapshots();
  }


  // Update user details in DB
  Future<void> updateUserDetails(userName, userPhone) async {
    String currentEmail = getCurrentUserEmail();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    var docRef =
    FirebaseFirestore.instance.collection('users').doc(user.docs.first.id);

    await docRef.update({
      "userName": userName,
      "userPhone": userPhone,
    });
  }

  // Creating a new recipe
  Future createRecipe(
      {required String recipeName,
        // required String recipeIcon,
        required String recipeDescription,
        required String instructions,
        required String recipeIcon,
        required List<String> ingredients,
        required int prepTime}) async {
    String currentEmail = getCurrentUserEmail();
    docRecipe = FirebaseFirestore.instance.collection('recipe').doc();

    final json = {
      'owner': currentEmail,
      'recipeName': recipeName,
      'ingredients': ingredients,
      'recipeIcon' : recipeIcon,
      'instructions': instructions,
      'recipeDescription': recipeDescription,
      'prepTime': prepTime,
      'useCounter': 0,
      'ratingAvg': 0,
      'ratingCounter': 0,

    };

    await docRecipe?.set(json);
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    var docRef =
    FirebaseFirestore.instance.collection('users').doc(user.docs.first.id);
    await docRef.update({
      "recipes": FieldValue.arrayUnion([recipeName])
    });
  }


  // Update recipe in DB
  Future<void> updateRecipe(recipeName, recipeDescription, recipeInstructions, recipeIcon, prepTime, ingredients) async {
    var recipe = await FirebaseFirestore.instance
        .collection('recipe')
        .where('recipeName', isEqualTo: recipeName)
        .get();
    var docRef =
    FirebaseFirestore.instance.collection('recipe').doc(recipe.docs.first.id);

    await docRef.update({
      "recipeDescription": recipeDescription,
      "instructions": recipeInstructions,
      "recipeIcon": recipeIcon,
      "prepTime": prepTime,
      "ingredients": ingredients
    });
  }

  // Reading recipe by name
  Future<QuerySnapshot<Map<String, dynamic>>> readRecipeByName(recipeName) =>
      FirebaseFirestore.instance
          .collection('recipe')
          .where('recipeName', isEqualTo: recipeName)
          .get();

  Stream<QuerySnapshot<Map<String, dynamic>>> readRecipesAsStream() {
    return FirebaseFirestore.instance.collection('recipe').snapshots();
  }


  // Removing user own recipe
  Future removeRecipeByUser(recipeName) async {
    String currentEmail = getCurrentUserEmail();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    var docRef = FirebaseFirestore.instance.collection('users').doc(user.docs.first.id);
    await docRef.update({
      "recipes": FieldValue.arrayRemove([recipeName])
    });

    await FirebaseFirestore.instance
        .collection('recipe')
        .where('recipeName', isEqualTo: recipeName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    final usersRef = FirebaseFirestore.instance.collection('users');
    final snapshot = await usersRef.get();
    for (final doc in snapshot.docs) {
      final favorites = List<String>.from(doc.data()['favorites'] ?? []);
      if (favorites.contains(recipeName)) {
        favorites.remove(recipeName);
        await doc.reference.update({'favorites': favorites});
      }
    }

  }


  // Reading recipes of current user
  Future<List<String>> readRecipesOfCurrentUser() async {
    String currentEmail = getCurrentUserEmail();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    return (user.docs.first
        .data()["recipes"] ?? [])
        .map<String>((e) => e.toString())
        .toList();
  }


  // Update user inventory in DB
  Future<void> updateUserInventory(String item, int op) async {
    String currentEmail = getCurrentUserEmail();
    item = item.toLowerCase();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    var docRef =
    FirebaseFirestore.instance.collection('users').doc(user.docs.first.id);
    if (op==1) {
      await docRef.update({
        "userInventory": FieldValue.arrayUnion([item])
      });
    } else {
      await docRef.update({
        "userInventory": FieldValue.arrayRemove([item])
      });
    }
  }

  // Reading favorites of current user
  Future<List<String>> readFavoritesOfCurrentUser() async {
    String currentEmail = getCurrentUserEmail();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    return (user.docs.first
        .data()["favorites"] ?? [])
        .map<String>((e) => e.toString())
        .toList();
  }


  // Updating favorites of current user
  Future<void> writeFavoritesOfCurrentUser(String recipeName) async {
    String currentEmail = getCurrentUserEmail();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    var docRef =
    FirebaseFirestore.instance.collection('users').doc(user.docs.first.id);
    if ((await docRef.get()).data()!["favorites"].contains(recipeName) == true) {
      await docRef.update({
        "favorites": FieldValue.arrayRemove([recipeName])
      });
    } else {
      await docRef.update({
        "favorites": FieldValue.arrayUnion([recipeName])
      });
    }
  }


  // Reading inventory of current user
  Future<List<String>> readInventoryOfCurrentUser() async {
    String currentEmail = getCurrentUserEmail();
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('userEmail', isEqualTo: currentEmail)
        .get();
    return (user.docs.first
        .data()["userInventory"] ?? [])
        .map<String>((e) => e.toString())
        .toList();
  }

  // Updating rating avarage by recipe name
  Future<void> updateRatingAvg(String recipeName, int rating) async {
    var recipe = await FirebaseFirestore.instance
      .collection('recipe')
      .where('recipeName', isEqualTo: recipeName)
      .get();
    var docRef =
    FirebaseFirestore.instance.collection('recipe').doc(recipe.docs.first.id);
    double ratingAvg = (recipe.docs.first.data()['ratingAvg'] ?? 0) / 1.0;
    int ratingCounter = recipe.docs.first.data()['ratingCounter'] ?? 0;
    ratingAvg = ((ratingAvg * ratingCounter) + rating) / (ratingCounter + 1);
    await docRef.update({
      "ratingCounter": FieldValue.increment(1),
      "ratingAvg": ratingAvg
    });
  }

  // Adding to use counter of recipe
  Future<void> addUseCounter(String recipeName) async {
    var model = await FirebaseFirestore.instance
        .collection('recipe')
        .where('recipeName', isEqualTo: recipeName)
        .get();
    var docRef =
    FirebaseFirestore.instance.collection('recipe').doc(model.docs.first.id);
    await docRef.update({
      "useCounter": FieldValue.increment(1)
    });
  }

  // Checking for substitute of ingredient and type
  Future<String> checkSubstitute(type, ingredient) async {
    var substitute = await FirebaseFirestore.instance
        .collection('substitutes').where('type', isEqualTo:type)
        .where('ingredient', isEqualTo: ingredient)
        .get();

    if (substitute.docs.isNotEmpty){
      return substitute.docs.first.data()['substitute'];
    }

    return ingredient;

  }

  // Reading all substitutes by type
  Stream<List>readSubstitutesByType(String type) {
    return FirebaseFirestore.instance
        .collection('substitutes')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => SubstituteModel.fromJson(doc.data()))
        .toList());
  }

  // Removing a specific substitute + type
  Future removeSubstitute(type, ingredient, substitute) async {
    await FirebaseFirestore.instance
        .collection('substitutes')
        .where('type', isEqualTo: type)
        .where('ingredient', isEqualTo: ingredient)
        .where('substitute', isEqualTo: substitute)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }


  // Creating new substitute
  Future createSubstitute(
      {required String type,
        required String ingredient,
        required String substitute,}) async {

    docRecipe = FirebaseFirestore.instance.collection('substitutes').doc();

    final json = {
      'type': type,
      'ingredient': ingredient,
      'substitute': substitute,
    };

    await docRecipe?.set(json);
  }

}
