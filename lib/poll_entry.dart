class PollEntry {

  bool? initialDecision;
  bool? finalDecision;

  PollEntry({this.initialDecision, this.finalDecision});

  @override
  String toString() {
    return 'PollEntry{initialDecision: $initialDecision, finalDecision: $finalDecision}';
  }

}