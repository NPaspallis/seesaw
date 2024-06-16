import 'package:cloud_firestore/cloud_firestore.dart';

import 'poll_data.dart';

class RECCaseStudyDB {

  static final FirebaseFirestore _i = FirebaseFirestore.instance;
  static final RECCaseStudyDB instance = RECCaseStudyDB();

  static const String id = "rec_data";

  static const String betterUnderstanding = "feedback_betterUnderstanding";
  static const String changedOpinion = "feedback_changedOpinion";
  static const String newInsights = "feedback_newInsights";
  static const String wouldRecommend = "feedback_wouldRecommend";

  static const List<String> feedbackQuestions = [
    betterUnderstanding,
    changedOpinion,
    newInsights,
    wouldRecommend
  ];

  static const String selection0 = "0s";
  static const String selection1 = "1s";
  static const String selection2 = "2s";
  static const String selection3 = "3s";
  static const String selection4 = "4s";
  static const String selection5 = "5s";
  static const String selection6 = "6s";
  static const String selection7 = "7s";

  static const List<String> selections = [
    selection0,
    selection1,
    selection2,
    selection3,
    selection4,
    selection5,
    selection6,
    selection7,
  ];

  static const String poll = "poll";
  static const String initialYes = "initialYes";
  static const String initialNo = "initialNo";
  static const String finalYes = "finalYes";
  static const String finalNo = "finalNo";
  static const String switchedToYes = "switchedToYes";
  static const String switchedToNo = "switchedToNo";

  //Retrieves the decision counter values.
  Future<PollData> getDecisionCounters(final String classroomUUID) async {
    print('getDecisionCounters: $classroomUUID'); // todo handle classroomUUID
    DocumentSnapshot doc = await _i.collection(id)
        .doc(poll)
        .get();

    PollData data = PollData(
        doc.get(initialYes),
        doc.get(initialNo),
        doc.get(finalYes),
        doc.get(finalNo),
        doc.get(switchedToYes),
        doc.get(switchedToNo),
    );
    return data;
  }

  //Atomically increments the initial yes decision counter.
  Future incrementInitialYesDecision(final String classroomUUID) async {
    print('incrementInitialYesDecision: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
      .doc(poll).update({
        initialYes: incrementOp
      });
  }

  //Atomically increments the initial no decision counter.
  Future incrementInitialNoDecision(final String classroomUUID) async {
    print('incrementInitialNoDecision: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      initialNo: incrementOp
    });
  }

  //Atomically increments the final yes decision counter.
  Future incrementFinalYesDecision(final String classroomUUID) async {
    print('incrementFinalYesDecision: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      finalYes: incrementOp
    });
  }

  //Atomically increments the final no decision counter.
  Future incrementFinalNoDecision(final String classroomUUID) async {
    print('incrementFinalNoDecision: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      finalNo: incrementOp
    });
  }

  //Atomically increments the switched to yes counter.
  Future incrementSwitchedToYes(final String classroomUUID) async {
    print('incrementSwitchedToYes: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      switchedToYes: incrementOp
    });
  }

  //Atomically increments the switched to no counter.
  Future incrementSwitchedToNo(final String classroomUUID) async {
    print('incrementSwitchedToNo: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      switchedToNo: incrementOp
    });
  }

  //Retrieves the data for a specific feedback question.
  Future<List<int>> getFeedbackCounters(String feedbackIdentifier) async {

    if (!feedbackQuestions.contains(feedbackIdentifier)) {
      throw Exception("Invalid feedback identifier '$feedbackIdentifier'");
    }

    DocumentSnapshot doc = await _i.collection(id)
        .doc(feedbackIdentifier)
        .get();

    List<int> data = List.filled(8, 0, growable: false);

    data[0] = doc.get(selection0);
    data[1] = doc.get(selection1);
    data[2] = doc.get(selection2);
    data[3] = doc.get(selection3);
    data[4] = doc.get(selection4);
    data[5] = doc.get(selection5);
    data[6] = doc.get(selection6);
    data[7] = doc.get(selection7);
    return data;
  }

  //Increments a specific selection (0-7 stars) for a specific feedback question.
  //Important note: 'selection' must be in the range 0-7.
  Future incrementFeedbackCounter(String feedbackIdentifier, int selection) async {

    if (!feedbackQuestions.contains(feedbackIdentifier)) {
      throw Exception("Invalid feedback identifier '$feedbackIdentifier'");
    }

    if (selection >= selections.length || selection < 0) {
      throw Exception("Invalid selection '${selection.toString()}' - must be in the range 0-${selections.length - 1} inclusive.");
    }

    final FieldValue incrementOp = FieldValue.increment(1);

    await _i.collection(id)
        .doc(feedbackIdentifier).update({
      selections[selection]: incrementOp
    });
  }

}

class TriageCaseStudyDB {

  static final FirebaseFirestore _i = FirebaseFirestore.instance;
  static final TriageCaseStudyDB instance = TriageCaseStudyDB();

  static const String id = "triage_data";

  static const String betterUnderstanding = "feedback_betterUnderstanding";
  static const String changedOpinion = "feedback_changedOpinion";
  static const String newInsights = "feedback_newInsights";
  static const String wouldRecommend = "feedback_wouldRecommend";

  static const List<String> feedbackQuestions = [
    betterUnderstanding,
    changedOpinion,
    newInsights,
    wouldRecommend
  ];

  static const String selection0 = "0s";
  static const String selection1 = "1s";
  static const String selection2 = "2s";
  static const String selection3 = "3s";
  static const String selection4 = "4s";
  static const String selection5 = "5s";
  static const String selection6 = "6s";
  static const String selection7 = "7s";

  static const List<String> selections = [
    selection0,
    selection1,
    selection2,
    selection3,
    selection4,
    selection5,
    selection6,
    selection7,
  ];

  static const String poll = "poll";
  static const String initialYes = "initialYes";
  static const String initialNo = "initialNo";
  static const String finalYes = "finalYes";
  static const String finalNo = "finalNo";
  static const String switchedToYes = "switchedToYes";
  static const String switchedToNo = "switchedToNo";

  //Retrieves the decision counter values.
  Future<PollData> getDecisionCounters() async {
    DocumentSnapshot doc = await _i.collection(id)
        .doc(poll)
        .get();

    PollData data = PollData(
      doc.get(initialYes),
      doc.get(initialNo),
      doc.get(finalYes),
      doc.get(finalNo),
      doc.get(switchedToYes),
      doc.get(switchedToNo),
    );
    return data;
  }

  //Atomically increments the initial yes decision counter.
  Future incrementInitialYesDecision() async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      initialYes: incrementOp
    });
  }

  //Atomically increments the initial no decision counter.
  Future incrementInitialNoDecision() async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      initialNo: incrementOp
    });
  }

  //Atomically increments the final yes decision counter.
  Future incrementFinalYesDecision() async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      finalYes: incrementOp
    });
  }

  //Atomically increments the final no decision counter.
  Future incrementFinalNoDecision() async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      finalNo: incrementOp
    });
  }

  //Atomically increments the switched to yes counter.
  Future incrementSwitchedToYes() async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      switchedToYes: incrementOp
    });
  }

  //Atomically increments the switched to no counter.
  Future incrementSwitchedToNo() async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(poll).update({
      switchedToNo: incrementOp
    });
  }

  //Retrieves the data for a specific feedback question.
  Future<List<int>> getFeedbackCounters(String feedbackIdentifier) async {

    if (!feedbackQuestions.contains(feedbackIdentifier)) {
      throw Exception("Invalid feedback identifier '$feedbackIdentifier'");
    }

    DocumentSnapshot doc = await _i.collection(id)
        .doc(feedbackIdentifier)
        .get();

    List<int> data = List.filled(8, 0, growable: false);

    data[0] = doc.get(selection0);
    data[1] = doc.get(selection1);
    data[2] = doc.get(selection2);
    data[3] = doc.get(selection3);
    data[4] = doc.get(selection4);
    data[5] = doc.get(selection5);
    data[6] = doc.get(selection6);
    data[7] = doc.get(selection7);
    return data;
  }

  //Increments a specific selection (0-7 stars) for a specific feedback question.
  //Important note: 'selection' must be in the range 0-7.
  Future incrementFeedbackCounter(String feedbackIdentifier, int selection) async {

    if (!feedbackQuestions.contains(feedbackIdentifier)) {
      throw Exception("Invalid feedback identifier '$feedbackIdentifier'");
    }

    if (selection >= selections.length || selection < 0) {
      throw Exception("Invalid selection '${selection.toString()}' - must be in the range 0-${selections.length - 1} inclusive.");
    }

    final FieldValue incrementOp = FieldValue.increment(1);

    await _i.collection(id)
        .doc(feedbackIdentifier).update({
      selections[selection]: incrementOp
    });
  }

}