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

  static const String initialYes = "initialYes";
  static const String initialNo = "initialNo";
  static const String finalYes = "finalYes";
  static const String finalNo = "finalNo";
  static const String switchedToYes = "switchedToYes";
  static const String switchedToNo = "switchedToNo";
  static const String createdOn = "createdOn";
  static const String modifiedOn = "modifiedOn";
  static const String isClassroom = "isClassroom";

  // todo check and delete all classroom documents that are older than 60 days old

  Future<void> initializeCaseStudyCounters(final String classroomUUID) async {
    print('Initializing case study counters for $id/$classroomUUID...');
    DocumentSnapshot snapshot = await _i.collection(id).doc(classroomUUID).get();
    if (!snapshot.exists) {
      print('Counters for $id/$classroomUUID do not exist. Initializing now...');
      await _i.collection(id)
        .doc(classroomUUID)
        .set({
          finalNo: 0,
          finalYes: 0,
          initialNo: 0,
          initialYes: 0,
          switchedToNo: 0,
          switchedToYes: 0,
          createdOn: DateTime.now().millisecondsSinceEpoch,
          modifiedOn: DateTime.now().millisecondsSinceEpoch,
          isClassroom: classroomUUID != "kioskUUID" ? true : false
        });
    }
  }

  //Retrieves the decision counter values.
  Future<PollData> getDecisionCounters(final String classroomUUID) async {
    print('getDecisionCounters: $classroomUUID'); // todo handle classroomUUID
    DocumentSnapshot doc = await _i.collection(id)
        .doc(classroomUUID)
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
      .doc(classroomUUID).update({
        initialYes: incrementOp,
        modifiedOn: DateTime.now().millisecondsSinceEpoch
      });
  }

  //Atomically increments the initial no decision counter.
  Future incrementInitialNoDecision(final String classroomUUID) async {
    print('incrementInitialNoDecision: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      initialNo: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the final yes decision counter.
  Future incrementFinalYesDecision(final String classroomUUID) async {
    print('incrementFinalYesDecision: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      finalYes: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the final no decision counter.
  Future incrementFinalNoDecision(final String classroomUUID) async {
    print('incrementFinalNoDecision: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      finalNo: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the switched to yes counter.
  Future incrementSwitchedToYes(final String classroomUUID) async {
    print('incrementSwitchedToYes: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      switchedToYes: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the switched to no counter.
  Future incrementSwitchedToNo(final String classroomUUID) async {
    print('incrementSwitchedToNo: $classroomUUID'); // todo handle classroomUUID
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      switchedToNo: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
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

  static const String initialYes = "initialYes";
  static const String initialNo = "initialNo";
  static const String finalYes = "finalYes";
  static const String finalNo = "finalNo";
  static const String switchedToYes = "switchedToYes";
  static const String switchedToNo = "switchedToNo";
  static const String createdOn = "createdOn";
  static const String modifiedOn = "modifiedOn";
  static const String isClassroom = "isClassroom";


  Future<void> initializeCaseStudyCounters(final String classroomUUID) async {
    print('Initializing case study counters for $id/$classroomUUID...');
    DocumentSnapshot snapshot = await _i.collection(id).doc(classroomUUID).get();
    if (!snapshot.exists) {
      print('Counters for $id/$classroomUUID do not exist. Initializing now...');
      await _i.collection(id)
          .doc(classroomUUID)
          .set({
        finalNo: 0,
        finalYes: 0,
        initialNo: 0,
        initialYes: 0,
        switchedToNo: 0,
        switchedToYes: 0,
        createdOn: DateTime.now().millisecondsSinceEpoch,
        modifiedOn: DateTime.now().millisecondsSinceEpoch,
        isClassroom: classroomUUID != "kioskUUID" ? true : false
      });
    }
  }

  //Retrieves the decision counter values.
  Future<PollData> getDecisionCounters(final String classroomUUID) async {
    DocumentSnapshot doc = await _i.collection(id)
        .doc(classroomUUID)
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
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      initialYes: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the initial no decision counter.
  Future incrementInitialNoDecision(final String classroomUUID) async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      initialNo: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the final yes decision counter.
  Future incrementFinalYesDecision(final String classroomUUID) async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      finalYes: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the final no decision counter.
  Future incrementFinalNoDecision(final String classroomUUID) async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      finalNo: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the switched to yes counter.
  Future incrementSwitchedToYes(final String classroomUUID) async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      switchedToYes: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
    });
  }

  //Atomically increments the switched to no counter.
  Future incrementSwitchedToNo(final String classroomUUID) async {
    var incrementOp = FieldValue.increment(1);
    await _i.collection(id)
        .doc(classroomUUID).update({
      switchedToNo: incrementOp,
      modifiedOn: DateTime.now().millisecondsSinceEpoch
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