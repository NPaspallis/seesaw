import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seesaw/thankyou.dart';

import 'main.dart';

const Color dividerColor = preparedWhiteColor;

class EvaluationPage extends StatefulWidget {

  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: preparedPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(50),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Divider(thickness: 1, color: dividerColor),

                      getRatingLine(0),

                      const Divider(thickness: 1, color: dividerColor),

                      getRatingLine(1),

                      const Divider(thickness: 1, color: dividerColor),

                      getRatingLine(2),

                      const Divider(thickness: 1, color: dividerColor),

                      getRatingLine(3),

                      const Divider(thickness: 1, color: dividerColor),

                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () => skip(context),
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: preparedSecondaryColor, //Set border color
                                      width: 2, //Set border width
                                    )
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('SKIP', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white))
                                ),
                              ),

                              const SizedBox(width: 20),

                              ElevatedButton(
                                onPressed: () => submit(context),
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(preparedSecondaryColor),
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('SUBMIT', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white))
                                )
                              )
                            ]
                          )
                      )
                    ]
                )
            )
        )
    );
  }

  Widget getRatingLine(final int index) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('The pandemic seesaw provided me with a better understanding of pandemic decision making', style: TextStyle(fontSize: 32, color: preparedWhiteColor)),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('fully disagree', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              getRatingBar(index),
              const SizedBox(width: 10),
              const Text('fully agree', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      )
    );
  }

  List<double> ratings = List<double>.filled(4, 0);

  RatingBar getRatingBar(final int index) {
    return RatingBar(
      initialRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 7,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star),
          half: const Icon(Icons.star_half),
          empty: const Icon(Icons.star_border)
      ),
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      onRatingUpdate: (rating) {
        ratings[index] = rating;
      },
    );
  }

  void skip(BuildContext context) {
    showSnack(context, 'No data were submitted');
    openThankYouPage(context);
  }

  void submit(BuildContext context) {
    debugPrint('ratings: $ratings');
    final bool anyRatingUnselected = ratings.any((element) => element == 0);
    if(anyRatingUnselected) {
      showSnack(context, 'You must choose a rating for each item before submitting');
    } else {
      showSnack(context, 'Your choices were submitted');
      openThankYouPage(context);
    }
  }

  void openThankYouPage(BuildContext context) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ThankYouPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            }
        )
    );
  }

  void showSnack(final BuildContext context, final String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, style: const TextStyle(fontSize: 24, color: preparedWhiteColor), textAlign: TextAlign.center,)));
  }
}