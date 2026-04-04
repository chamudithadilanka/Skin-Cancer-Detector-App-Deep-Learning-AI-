import 'dart:convert';

class RecentPrediction {
  final String imagePath;
  final String predictionLabel;
  final double confidence;
  final DateTime savedAt;

  RecentPrediction({
    required this.imagePath,
    required this.predictionLabel,
    required this.confidence,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'predictionLabel': predictionLabel,
    'confidence': confidence,
    'savedAt': savedAt.toIso8601String(),
  };

  factory RecentPrediction.fromJson(Map<String, dynamic> json) =>
      RecentPrediction(
        imagePath: json['imagePath'],
        predictionLabel: json['predictionLabel'],
        confidence: json['confidence'],
        savedAt: DateTime.parse(json['savedAt']),
      );

  static String encode(List<RecentPrediction> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<RecentPrediction> decode(String data) =>
      (jsonDecode(data) as List)
          .map((e) => RecentPrediction.fromJson(e))
          .toList();
}