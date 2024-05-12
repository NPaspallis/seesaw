import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seesaw/feedback_entry.dart';
import 'package:seesaw/poll_entry.dart';
import 'package:uuid/uuid.dart';

class ParticipantEntry {

  static ParticipantEntry? currentEntry; //Stores the current (temporary) entry
  static const String name = "ParticipantEntry";

  String participantID = const Uuid().v4();
  PollEntry? pollEntry;
  FeedbackEntry? feedbackEntry;

  ParticipantEntry({this.pollEntry, this.feedbackEntry});

  Map<String, dynamic> toJson() {
    return {
      "participantID": participantID,
      "pollEntry": {
        "initialDecision": pollEntry?.initialDecision,
        "finalDecision": pollEntry?.finalDecision
      },
      "feedbackEntry": feedbackEntry != null ? {
        "betterUnderstanding": feedbackEntry!.betterUnderstanding,
        "newInsights": feedbackEntry!.newInsights,
        "changedOpinion": feedbackEntry!.changedOpinion,
        "wouldRecommend": feedbackEntry!.wouldRecommend
      } : null
    };
  }

  static ParticipantEntry fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    ParticipantEntry participantEntry = ParticipantEntry(
      pollEntry: data?["pollEntry"] != null ? PollEntry(
        initialDecision: data?["pollEntry"]["initialDecision"] == null ? null : data?["pollEntry"]["initialDecision"] as bool,
        finalDecision: data?["pollEntry"]["finalDecision"] == null ? null : data?["pollEntry"]["finalDecision"] as bool,
      ) : null,
      feedbackEntry: data?["feedbackEntry"] != null ? FeedbackEntry(
        data?["feedbackEntry"]["betterUnderstanding"] as int,
        data?["feedbackEntry"]["newInsights"] as int,
        data?["feedbackEntry"]["changedOpinion"] as int,
        data?["feedbackEntry"]["wouldRecommend"] as int,
      ) : null
    );
    participantEntry.participantID = data?["participantID"] as String;
    return participantEntry;
  }

  @override
  String toString() {
    return 'ParticipantEntry{participantID: $participantID, pollEntry: $pollEntry, feedbackEntry: $feedbackEntry}';
  }

}