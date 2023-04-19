import 'package:auto_sweet_recipe/pages/pageRecipeFather.dart';
import 'package:flutter/material.dart';
import '../services/firebaseService.dart';

late FirebaseService firebaseService;


class PageRatePopUp extends StatefulWidget {
  static const maxStarVal = 5;
  var starVal = 0;
  TextEditingController rateController = TextEditingController();

  PageRatePopUp({Key? key}) : super(key: key) {
    firebaseService = FirebaseService();
    starVal = 0;
  }

  @override
  State<PageRatePopUp> createState() => _PageRatePopUpState();
}

class _PageRatePopUpState extends State<PageRatePopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FloatingActionButton.extended(
            heroTag: "Sending",
            onPressed: () async {
              //If text missing data
              if (widget.starVal == 0) {
              } else {
                firebaseService.updateRatingAvg(RECIPE_NAME, widget.starVal);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Thanks for your rating!",
                          textAlign: TextAlign.left)),
                );
                Navigator.of(context).pop();
              }
            },
            backgroundColor: Color.fromARGB(204, 126, 247, 134),
            foregroundColor: Colors.black,
            icon: const Icon(
              Icons.send,
              color: Colors.black,
            ),
            label: const Text("Send",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black)),
          ),
          FloatingActionButton.extended(
            heroTag: "cancel",
            onPressed: () async {
              Navigator.of(context).pop();
            },
            backgroundColor: const Color.fromARGB(204, 245, 122, 106),
            foregroundColor: Colors.black,
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            label: const Text("Cancel",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black)),
          ),
        ])
      ],
      title: const Text('Your rating is important to us'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Text("Please rate the recipe"),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var star in ["1", "2", "3", "4", "5"])
                      IconButton(
                          onPressed: () {
                            setState(() {
                              widget.starVal = int.parse(star);
                            });
                          },
                          icon: Icon(
                              (int.parse(star) <= widget.starVal)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color.fromARGB(255, 244, 200, 25),
                              size: 40))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
