class RecipeCardData {
  String title;
  List<String>? stringList;
  int showUpTo;
  String? imageUrl;

  RecipeCardData(
      {this.title = "",
        this.stringList,
        this.imageUrl,
        this.showUpTo = 1}
      );
}
