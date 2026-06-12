import 'gait_result.dart';

class GaitSession {
  final String id;
  final DateTime date;
  final String classification;
  final String severity;
  final GaitResult result;

  /// Firebase Storage download URLs for the exported artifacts
  /// (set after a successful upload; null when not uploaded).
  final String? csvUrl;
  final String? pdfUrl;

  const GaitSession({
    required this.id,
    required this.date,
    required this.classification,
    required this.severity,
    required this.result,
    this.csvUrl,
    this.pdfUrl,
  });

  GaitSession copyWith({String? csvUrl, String? pdfUrl}) => GaitSession(
        id: id,
        date: date,
        classification: classification,
        severity: severity,
        result: result,
        csvUrl: csvUrl ?? this.csvUrl,
        pdfUrl: pdfUrl ?? this.pdfUrl,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'classification': classification,
        'severity': severity,
        'result': result.toJson(),
        'csvUrl': csvUrl,
        'pdfUrl': pdfUrl,
      };

  factory GaitSession.fromJson(Map<String, dynamic> json) => GaitSession(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        classification: json['classification'] as String,
        severity: json['severity'] as String,
        result: GaitResult.fromJson(json['result'] as Map<String, dynamic>),
        csvUrl: json['csvUrl'] as String?,
        pdfUrl: json['pdfUrl'] as String?,
      );
}
