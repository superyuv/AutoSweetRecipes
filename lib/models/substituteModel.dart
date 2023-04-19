//Define model item for Firestore sync

class SubstituteModel {
  String ingredient;
  final String substitute;
  final String type;

  SubstituteModel(
      {this.ingredient = '',
      required this.substitute,
      required this.type,
      });

  Map<String, dynamic> toJson() => {
        'ingredient': ingredient,
        'substitute': substitute,
        'type': type,
      };

  static SubstituteModel fromJson(Map<String, dynamic> json) => SubstituteModel(
      ingredient: json['ingredient'],
      substitute: json['substitute'],
      type: json['type'],
      );
}
