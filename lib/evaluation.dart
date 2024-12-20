import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/state_model.dart';

import 'db.dart';
import 'main.dart';

const Color dividerColor = Colors.white60;

const lines = <String>[
  'The pandemic Seesaw provided me with a better understanding of pandemic decision making.',
  'The pandemic Seesaw gave me new insights into other’s perspectives related to pandemic decision making',
  'I have changed my opinion about some aspect of pandemic decision making (this is not totally captured in the process - someone might still make the same final decision but some aspect of their opinion might still have changed)',
  'I would recommend the pandemic Seesaw to others.'
];

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  @override
  Widget build(BuildContext context) {

    final ScrollController questionsScrollController = ScrollController();

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        color: preparedPrimaryColor,
        child: Padding(
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 8, 50, MediaQuery.of(context).size.width / 8, 50),
            child: RawScrollbar(
              thumbColor: Colors.white60,
              thumbVisibility: true,
              controller: questionsScrollController,
              child: SingleChildScrollView(
                controller: questionsScrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getPrompt(),
                      const Gap(20),
                      const Divider(thickness: 1, color: dividerColor),
                      getRatingLine(0),
                      const Divider(thickness: 1, color: dividerColor),
                      getRatingLine(1),
                      const Divider(thickness: 1, color: dividerColor),
                      getRatingLine(2),
                      const Divider(thickness: 1, color: dividerColor),
                      getRatingLine(3),
                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getOutlinedButton(
                                    context, 'SKIP', () => skip(context)),
                                const SizedBox(width: 20),
                                getElevatedButton(
                                    context, 'SUBMIT', () => submit(context)),
                              ]))
                    ])),
            ))
            );
  }

  Widget getPrompt() {
    return const Text(
        'Please provide your feedback on the following questions, by choosing 1-7 stars for each answer.',
        style: TextStyle(fontSize: textSizeMedium  , color: preparedOrangeColor, fontWeight: FontWeight.bold,),
      textAlign: TextAlign.justify,
    );
  }

  Widget getRatingLine(final int index) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                lines[index],
                style: const TextStyle(fontSize: textSizeSmall, color: preparedWhiteColor)),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Fully disagree', style: TextStyle(fontSize: textSizeSmaller, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 20),
                getRatingBar(index),
                const SizedBox(width: 20),
                const Text('Fully agree', style: TextStyle(fontSize: textSizeSmaller, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ],
        ));
  }

  List<double> ratings = List<double>.filled(4, 0);

  RatingBar getRatingBar(final int index) {
    return RatingBar(
      initialRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      maxRating: 7,
      minRating: 0,
      itemCount: 7,
      glowColor: Colors.yellow,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.yellow,),
          half: const Icon(Icons.star_half, color: Colors.yellow,),
          empty: const Icon(Icons.star_border, color: Colors.yellow,)),
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
    if (anyRatingUnselected) {
      showSnack(
          context, 'You must choose a rating for each item before submitting');
    } else {
      showSnack(context, 'Your choices were submitted');

      //Process feedback
      var db = RECCaseStudyDB.instance;

      List<Future> futures = [];

      futures.add(db.incrementFeedbackCounter(RECCaseStudyDB.betterUnderstanding, ratings[0] as int));
      futures.add(db.incrementFeedbackCounter(RECCaseStudyDB.changedOpinion, ratings[1] as int));
      futures.add(db.incrementFeedbackCounter(RECCaseStudyDB.newInsights, ratings[2] as int));
      futures.add(db.incrementFeedbackCounter(RECCaseStudyDB.wouldRecommend, ratings[3] as int));

      Future.wait(futures)
          .then((value) => openThankYouPage(context),)
          .onError((error, stackTrace) {
            debugPrint(error.toString());
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.red,
                title: const Text("Error"),
                content: const Text("There was an error submitting your feedback", style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.error, color: Colors.white,),
                actions: [

                  //Skip button
                  OutlinedButton(
                    onPressed: () {
                      openThankYouPage(context);
                    },
                    child: const Text("Skip")
                  ),

                  //Try again button
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        submit(context);
                      },
                      child: const Text("Try again")
                  )
                ],
              );
            },);
         });
    }
  }

  void openThankYouPage(BuildContext context) {
    final StateModel stateModel =
        Provider.of<StateModel>(context, listen: false);
    stateModel.setSeesawState(SeesawState.thankYou);
  }

  void showSnack(final BuildContext context, final String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: const TextStyle(fontSize: 24, color: preparedWhiteColor),
      textAlign: TextAlign.center,
    )));
  }
}
