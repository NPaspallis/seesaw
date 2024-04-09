import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/buttons.dart';
import 'package:seesaw/state_model.dart';

import 'main.dart';

const Color dividerColor = preparedDarkShadeColor;

const lines = <String>[
  'The pandemic seesaw provided me with a better understanding of pandemic decision making.',
  'The pandemic seesaw gave me new insights into other’s perspectives related to pandemic decision making',
  'I have changed my opinion about some aspect of pandemic decision making (this is not totally captured in the process - someone might still make the same final decision but some aspect of their opinion might still have changed)',
  'I would recommend the pandemic seesaw to others'
];

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: preparedPrimaryColor,
        child: Padding(
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 8, 50, MediaQuery.of(context).size.width / 8, 50),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getPrompt(),
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
                  ])))
            );
  }

  Widget getPrompt() {
    return const Text(
        'Please provide your feedback on the following questions, by choosing 1-7 stars for each answer.',
        style: TextStyle(fontSize: textSizeMedium  , color: preparedSecondaryColor));
  }

  Widget getRatingLine(final int index) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
                lines[index],
                style: const TextStyle(fontSize: textSizeMedium, color: preparedWhiteColor)),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('fully disagree', style: TextStyle(fontSize: textSizeSmallest)),
                const SizedBox(width: 10),
                getRatingBar(index),
                const SizedBox(width: 10),
                const Text('fully agree', style: TextStyle(fontSize: textSizeSmallest)),
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
      itemCount: 7,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star),
          half: const Icon(Icons.star_half),
          empty: const Icon(Icons.star_border)),
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
      openThankYouPage(context);
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
