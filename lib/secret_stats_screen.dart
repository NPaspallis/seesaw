import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:seesaw/participant_entry.dart';

import 'main.dart';

class SecretStatsScreen extends StatefulWidget {

  const SecretStatsScreen({super.key});

  @override
  State createState() => _SecretStatsScreenState();
}

class _SecretStatsScreenState extends State<SecretStatsScreen> {

  bool authenticated = false;
  final TextEditingController _passwordController = TextEditingController();

  int _yesBeforeVideo = 0;
  int _noBeforeVideo = 0;
  int _yesAfterVideo = 0;
  int _noAfterVideo = 0;
  int _yesToNoDiff = 0;
  int _noToYesDiff = 0;

  double _betterUnderstandingAverage = 0;
  double _newInsightsAverage = 0;
  double _changedOpinionAverage = 0;
  double _wouldRecommendAverage = 0;

  final TextStyle statisticTextStyle = const TextStyle(color: Colors.white, fontSize: 20);
  final TextStyle headingTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 30,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white
  );

  getResponses() async {

    _noBeforeVideo = 0;
    _yesBeforeVideo = 0;
    _yesAfterVideo = 0;
    _noAfterVideo = 0;
    _noToYesDiff = 0;
    _yesToNoDiff = 0;

    var snapshot = await FirebaseFirestore.instance
        .collection(ParticipantEntry.name)
        .get();

    int betterUnderstandingSum = 0;
    int newInsightsSum = 0;
    int changedOpinionSum = 0;
    int wouldRecommendSum = 0;

    int _sumOfEntriesWithFeedback = 0;

    for (DocumentSnapshot doc in snapshot.docs) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = doc as DocumentSnapshot<Map<String, dynamic>>;
      ParticipantEntry entry = ParticipantEntry.fromDocumentSnapshot(snapshot);

      if (entry.pollEntry != null) {

        //Compute initial decision
        if (entry.pollEntry!.initialDecision!) {
          _yesBeforeVideo++;
        }
        else {
          _noBeforeVideo++;
        }

        if (entry.pollEntry!.finalDecision != null) {
          //Compute final decision
          if (entry.pollEntry!.finalDecision!) {
            _yesAfterVideo++;
          }
          else {
            _noAfterVideo++;
          }

          //Compute change from yes to no:
          if (entry.pollEntry!.initialDecision! == true && entry.pollEntry!.finalDecision! == false) {
            _yesToNoDiff++;
          }

          //Compute change from no to yes:
          if (entry.pollEntry!.initialDecision! == false && entry.pollEntry!.finalDecision! == true) {
            _noToYesDiff++;
          }
        }

      }

      //Compound feedback values:
      if (entry.feedbackEntry != null) {
        _sumOfEntriesWithFeedback++;
        betterUnderstandingSum += entry.feedbackEntry!.betterUnderstanding;
        newInsightsSum += entry.feedbackEntry!.newInsights;
        changedOpinionSum += entry.feedbackEntry!.changedOpinion;
        wouldRecommendSum += entry.feedbackEntry!.wouldRecommend;
      }

      debugPrint("Sum of entries with feedback:");
      debugPrint(_sumOfEntriesWithFeedback.toString());

    }

    //Calculate feedback entry averages
    _betterUnderstandingAverage = betterUnderstandingSum / _sumOfEntriesWithFeedback;
    _newInsightsAverage = newInsightsSum / _sumOfEntriesWithFeedback;
    _changedOpinionAverage = changedOpinionSum / _sumOfEntriesWithFeedback;
    _wouldRecommendAverage = wouldRecommendSum / _sumOfEntriesWithFeedback;

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Seesaw App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: preparedPrimaryColor),
          primaryColor: preparedPrimaryColor,
          splashColor: preparedSecondaryColor,
          // fontFamily: 'Open Sans',
          useMaterial3: true,
        ),
        home: Scaffold(
            body: Container(
              color: preparedPrimaryColor,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    body: authenticated ? getMainFragment() : getAuthFragment(),
                  )
              ),
            )
        )
    );
  }

  Widget getAuthFragment() {
    return Center(
        child: Form(
          child: Column(
            children: [

              const Text(
                "Please enter the password to see stats.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30),
              ),

              const Gap(30),

              //Password field
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    hintStyle: TextStyle(
                      color: Colors.teal.shade100,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.number,
                ),
              ),

              const Gap(30),

              //Ok button
              ElevatedButton(
                child: const Text("OK", style: TextStyle(fontSize: 30),),
                onPressed: () {
                  authenticate();
                },
              )

            ],
          ),
        ),
      );
  }

  Widget getMainFragment() {

    return FutureBuilder(
      future: getResponses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        else {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            debugPrint((snapshot.error as Error).stackTrace.toString());

            return Center(
              child: Column(
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.white,),
                  const SizedBox(height: 20,),
                  const Text("An error occurred while reading data from the server. Please try again.", style: TextStyle(color: Colors.white),),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() { });
                    },
                    child: const Text("Try again"),
                  )
                ],
              ),
            );
          }
          else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Gap(30),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: Colors.teal.shade900,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Responses before Charles Weijer video", style: headingTextStyle),
                                  const Gap(20),
                                  Text("Yes: $_yesBeforeVideo", style: statisticTextStyle,),
                                  Text("No: $_noBeforeVideo", style: statisticTextStyle,),
                                ],
                              ),
                            ),
                          )
                        ),

                        Expanded(
                          flex: 1,
                          child: Card(
                            color: Colors.teal.shade900,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Responses after Charles Weijer video", style: headingTextStyle),
                                  const Gap(20),
                                  Text("Yes: $_yesAfterVideo -- ($_noToYesDiff No changed to Yes)" , style: statisticTextStyle,),
                                  Text("No: $_noAfterVideo -- ($_yesToNoDiff Yes changed to No)" , style: statisticTextStyle,),
                                ],
                              ),
                            ),
                          )
                        )
                      ],
                    ),

                    const Gap(30),

                    const Divider(),

                    const Gap(30),

                    Text("Feedback responses", style: headingTextStyle),

                    const Gap(30),

                    //Understanding rating
                    SizedBox(
                      child: Card(
                        color: Colors.teal.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\"The pandemic seesaw provided me with a better "
                                  "understanding of pandemic decision making.\"",
                                style: statisticTextStyle,
                              ),

                              const Divider(),

                              Text("️ ► Average rating: ${_betterUnderstandingAverage.toStringAsFixed(2)}/7", style: statisticTextStyle,)
                            ],
                          ),
                        ),
                      ),
                    ),

                    //New insights rating
                    SizedBox(
                      child: Card(
                        color: Colors.teal.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\"The pandemic seesaw gave me new insights into other’s perspectives related to pandemic decision making\"",
                                style: statisticTextStyle,
                              ),

                              const Divider(),

                              Text("️ ► Average rating: ${_newInsightsAverage.toStringAsFixed(2)}/7", style: statisticTextStyle,)
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Changed opinion rating
                    SizedBox(
                      child: Card(
                        color: Colors.teal.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\"I have changed my opinion about some aspect of pandemic decision making (this is not totally captured in the process - someone might still make the same final decision but some aspect of their opinion might still have changed)\"",
                                style: statisticTextStyle,
                              ),

                              const Divider(),

                              Text("️ ► Average rating: ${_changedOpinionAverage.toStringAsFixed(2)}/7", style: statisticTextStyle,)
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Would recommend rating
                    SizedBox(
                      child: Card(
                        color: Colors.teal.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\"I would recommend the pandemic seesaw to others\"",
                                style: statisticTextStyle,
                              ),

                              const Divider(),

                              Text("️ ► Average rating: ${_wouldRecommendAverage.toStringAsFixed(2)}/7", style: statisticTextStyle,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  authenticate() {
    final String inputPassword = _passwordController.text;
    if (inputPassword == "134679") {
      setState(() {
        authenticated = true;
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          content: Text("Invalid password. Please try again.", style: TextStyle(color: Colors.white),),
        )
      );
    }
  }
}