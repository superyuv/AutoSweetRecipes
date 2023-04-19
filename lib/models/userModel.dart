//Define model item for Firestore sync

class User {
  final String userEmail;
  String userName;
  String userPhone;
  List<dynamic> userInventory;
  List<dynamic> favorites;
  List<dynamic> recipes;

  User(
      {this.userEmail = '',
        required this.userName,
        required this.userPhone,
        required this.userInventory,
        required this.favorites,
        required this.recipes,
      });

  Map<String, dynamic> toJson() => {
    'userEmail': userEmail,
    'userName': userName,
    'userPhone': userPhone,
    'userInventory': userInventory,
    'favorites': favorites,
    'recipes': recipes,
  };

  static User fromJson(Map<String, dynamic> json) => User(
      userEmail: json['userEmail'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      userInventory: json['userInventory'] ?? [],
      favorites: json['favorites'] ?? [],
    recipes: json['recipes'] ?? [],
  );
}
