import 'gait_result.dart';

class GaitSession {
  final String id;
  final DateTime date;
  final String classification;
  final String severity;
  final GaitResult result;

  const GaitSession({
    required this.id,
    required this.date,
    required this.classification,
    required this.severity,
    required this.result,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'classification': classification,
        'severity': severity,
        'result': result.toJson(),
      };

  factory GaitSession.fromJson(Map<String, dynamic> json) => GaitSession(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        classification: json['classification'] as String,
        severity: json['severity'] as String,
        result: GaitResult.fromJson(json['result'] as Map<String, dynamic>),
      );
}
