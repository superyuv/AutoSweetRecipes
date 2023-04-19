import 'package:flutter/cupertino.dart';

class PageNameProvider with ChangeNotifier {
  PageNameProvider(String PageNameProvider) {
    page = PageNameProvider;
  }
  var page = "MyAutoSweetRecipe";
  setPageName(String name) {
    page = name;
    notifyListeners();
  }
  
}
