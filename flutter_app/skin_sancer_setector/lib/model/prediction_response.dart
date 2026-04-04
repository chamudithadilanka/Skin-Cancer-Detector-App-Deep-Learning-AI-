class PredictionResponse {
  final bool success;
  final String disclaimer;
  final Prediction prediction;
  final List<TopPrediction> top3;
  final DoctorAdvice? doctorAdvice;
  final DiseaseInfo? diseaseInfo;
  final List<String> emergencySigns;

  PredictionResponse({
    required this.success,
    required this.disclaimer,
    required this.prediction,
    required this.top3,
    required this.doctorAdvice,
    required this.diseaseInfo,
    required this.emergencySigns,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      success: json['success'] ?? false,
      disclaimer: json['disclaimer'] ?? '',
      prediction: Prediction.fromJson(json['prediction'] ?? {}),
      top3: (json['top3'] as List? ?? [])
          .map((e) => TopPrediction.fromJson(e))
          .toList(),
      doctorAdvice: json['doctor_advice'] != null
          ? DoctorAdvice.fromJson(json['doctor_advice'])
          : null,
      diseaseInfo: json['disease_info'] != null
          ? DiseaseInfo.fromJson(json['disease_info'])
          : null,
      emergencySigns: List<String>.from(json['emergency_signs'] ?? []),
    );
  }
}

class Prediction {
  final String classKey;
  final double confidence;
  final String name;
  final String risk;
  final String riskColor;
  final String riskLabel;

  Prediction({
    required this.classKey,
    required this.confidence,
    required this.name,
    required this.risk,
    required this.riskColor,
    required this.riskLabel,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      classKey: json['class_key'] ?? '',
      confidence: (json['confidence'] ?? 0).toDouble(),
      name: json['name'] ?? '',
      risk: json['risk'] ?? '',
      riskColor: json['risk_color'] ?? '',
      riskLabel: json['risk_label'] ?? '',
    );
  }
}

class TopPrediction {
  final String classKey;
  final double confidence;
  final String name;

  TopPrediction({
    required this.classKey,
    required this.confidence,
    required this.name,
  });

  factory TopPrediction.fromJson(Map<String, dynamic> json) {
    return TopPrediction(
      classKey: json['class_key'] ?? '',
      confidence: (json['confidence'] ?? 0).toDouble(),
      name: json['name'] ?? '',
    );
  }
}

class DoctorAdvice {
  final String specialist;
  final String urgency;
  final String urgencyLevel;
  final String whatToSay;
  final List<String> testsExpect;
  final List<String> questionsToAsk;

  DoctorAdvice({
    required this.specialist,
    required this.urgency,
    required this.urgencyLevel,
    required this.whatToSay,
    required this.testsExpect,
    required this.questionsToAsk,
  });

  factory DoctorAdvice.fromJson(Map<String, dynamic> json) {
    return DoctorAdvice(
      specialist: json['specialist'] ?? '',
      urgency: json['urgency'] ?? '',
      urgencyLevel: json['urgency_level'] ?? '',
      whatToSay: json['what_to_say'] ?? '',
      testsExpect: List<String>.from(json['tests_expect'] ?? []),
      questionsToAsk: List<String>.from(json['questions_to_ask'] ?? []),
    );
  }
}

class DiseaseInfo {
  final String whatIsIt;
  final List<String> symptoms;
  final List<String> homeCare;

  DiseaseInfo({
    required this.whatIsIt,
    required this.symptoms,
    required this.homeCare,
  });

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) {
    return DiseaseInfo(
      whatIsIt: json['what_is_it'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      homeCare: List<String>.from(json['home_care'] ?? []),
    );
  }
}