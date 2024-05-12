import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class FeedbackEntry {

  int betterUnderstanding;
  int newInsights;
  int changedOpinion;
  int wouldRecommend;

  FeedbackEntry(this.betterUnderstanding, this.newInsights, this.changedOpinion,
      this.wouldRecommend);

  @override
  String toString() {
    return 'FeedbackEntry{betterUnderstanding: $betterUnderstanding, newInsights: $newInsights, changedOpinion: $changedOpinion, wouldRecommend: $wouldRecommend}';
  }

}