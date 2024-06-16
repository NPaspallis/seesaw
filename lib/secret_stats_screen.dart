import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:seesaw/seesaw_app.dart';

import 'db.dart';
import 'poll_data.dart';
import 'main.dart';

class SecretStatsScreen extends StatefulWidget {
  const SecretStatsScreen({super.key});

  @override
  State createState() => _SecretStatsScreenState();
}

class _SecretStatsScreenState extends State<SecretStatsScreen> {

  bool authenticated = false;
  final TextEditingController _passwordController = TextEditingController();

  PollData? pollData;
  List<int> betterUnderstanding = List.filled(8, 0);
  List<int> changedOpinion = List.filled(8, 0);
  List<int> newInsights = List.filled(8, 0);
  List<int> wouldRecommend = List.filled(8, 0);

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

    var db = RECCaseStudyDB.instance;

    //Get poll & feedback values:
    pollData = await db.getDecisionCounters(defaultClassroomUUID);
    betterUnderstanding = await db.getFeedbackCounters(RECCaseStudyDB.betterUnderstanding);
    changedOpinion = await db.getFeedbackCounters(RECCaseStudyDB.changedOpinion);
    newInsights = await db.getFeedbackCounters(RECCaseStudyDB.newInsights);
    wouldRecommend = await db.getFeedbackCounters(RECCaseStudyDB.wouldRecommend);

    int betterUnderstandingSum = 0;
    int newInsightsSum = 0;
    int changedOpinionSum = 0;
    int wouldRecommendSum = 0;

    int betterUnderstandingEntries = 0;
    int newInsightsEntries = 0;
    int changedOpinionEntries = 0;
    int wouldRecommendEntries = 0;

    //Find num of entries and sum of stars for each feedback question:
    for (int selection = 0; selection < betterUnderstanding.length; selection++) {
      betterUnderstandingSum += betterUnderstanding[selection] * selection;
      betterUnderstandingEntries += betterUnderstanding[selection];
    }

    for (int selection = 0; selection < changedOpinion.length; selection++) {
      changedOpinionSum += changedOpinion[selection] * selection;
      changedOpinionEntries += changedOpinion[selection];
    }

    for (int selection = 0; selection < newInsights.length; selection++) {
      newInsightsSum += newInsights[selection] * selection;
      newInsightsEntries += newInsights[selection];
    }

    for (int selection = 0; selection < wouldRecommend.length; selection++) {
      wouldRecommendSum += wouldRecommend[selection] * selection;
      wouldRecommendEntries += wouldRecommend[selection];
    }

    //Calculate feedback entry averages
    _betterUnderstandingAverage = betterUnderstandingSum / betterUnderstandingEntries;
    _changedOpinionAverage = changedOpinionSum / changedOpinionEntries;
    _newInsightsAverage = newInsightsSum / newInsightsEntries;
    _wouldRecommendAverage = wouldRecommendSum / wouldRecommendEntries;

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
                                  Text("Yes: ${pollData!.initialYes}", style: statisticTextStyle,),
                                  Text("No: ${pollData!.initialNo}", style: statisticTextStyle,),
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
                                  Text("Yes: ${pollData!.finalYes} -- (${pollData!.switchedToYes} No changed to Yes)" , style: statisticTextStyle,),
                                  Text("No: ${pollData!.finalNo} -- (${pollData!.switchedToNo} Yes changed to No)" , style: statisticTextStyle,),
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

                              Text("0 stars:  ${betterUnderstanding[0]}", style: statisticTextStyle,),
                              Text("1 star:  ${betterUnderstanding[1]}", style: statisticTextStyle,),
                              Text("2 stars:  ${betterUnderstanding[2]}", style: statisticTextStyle,),
                              Text("3 stars:  ${betterUnderstanding[3]}", style: statisticTextStyle,),
                              Text("4 stars:  ${betterUnderstanding[4]}", style: statisticTextStyle,),
                              Text("5 stars:  ${betterUnderstanding[5]}", style: statisticTextStyle,),
                              Text("6 stars:  ${betterUnderstanding[6]}", style: statisticTextStyle,),
                              Text("7 stars:  ${betterUnderstanding[7]}", style: statisticTextStyle,),

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

                              Text("0 stars:  ${newInsights[0]}", style: statisticTextStyle,),
                              Text("1 star:  ${newInsights[1]}", style: statisticTextStyle,),
                              Text("2 stars:  ${newInsights[2]}", style: statisticTextStyle,),
                              Text("3 stars:  ${newInsights[3]}", style: statisticTextStyle,),
                              Text("4 stars:  ${newInsights[4]}", style: statisticTextStyle,),
                              Text("5 stars:  ${newInsights[5]}", style: statisticTextStyle,),
                              Text("6 stars:  ${newInsights[6]}", style: statisticTextStyle,),
                              Text("7 stars:  ${newInsights[7]}", style: statisticTextStyle,),

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

                              Text("0 stars:  ${changedOpinion[0]}", style: statisticTextStyle,),
                              Text("1 star:  ${changedOpinion[1]}", style: statisticTextStyle,),
                              Text("2 stars:  ${changedOpinion[2]}", style: statisticTextStyle,),
                              Text("3 stars:  ${changedOpinion[3]}", style: statisticTextStyle,),
                              Text("4 stars:  ${changedOpinion[4]}", style: statisticTextStyle,),
                              Text("5 stars:  ${changedOpinion[5]}", style: statisticTextStyle,),
                              Text("6 stars:  ${changedOpinion[6]}", style: statisticTextStyle,),
                              Text("7 stars:  ${changedOpinion[7]}", style: statisticTextStyle,),

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

                              Text("0 stars:  ${wouldRecommend[0]}", style: statisticTextStyle,),
                              Text("1 star:  ${wouldRecommend[1]}", style: statisticTextStyle,),
                              Text("2 stars:  ${wouldRecommend[2]}", style: statisticTextStyle,),
                              Text("3 stars:  ${wouldRecommend[3]}", style: statisticTextStyle,),
                              Text("4 stars:  ${wouldRecommend[4]}", style: statisticTextStyle,),
                              Text("5 stars:  ${wouldRecommend[5]}", style: statisticTextStyle,),
                              Text("6 stars:  ${wouldRecommend[6]}", style: statisticTextStyle,),
                              Text("7 stars:  ${wouldRecommend[7]}", style: statisticTextStyle,),

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