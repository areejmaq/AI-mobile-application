final class CancerModel {
  final String label;
  final double confidence_score;

  CancerModel({required this.label, required this.confidence_score});

  factory CancerModel.fromMap(Map<String, dynamic> map) => CancerModel(
      label: map['label'], confidence_score: map["confidence_score"]);
}
