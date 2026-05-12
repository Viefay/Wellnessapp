import 'semiogram_result.dart';

class GaitResult {
  final int fmaLeScore;
  final String severity;
  final String classification;
  final double confidence;
  final int heelStrikeCount;
  final int toeOffCount;
  final SemiogramResult semiogram;

  const GaitResult({
    required this.fmaLeScore,
    required this.severity,
    required this.classification,
    required this.confidence,
    required this.heelStrikeCount,
    required this.toeOffCount,
    required this.semiogram,
  });

  Map<String, dynamic> toJson() => {
        'fmaLeScore': fmaLeScore,
        'severity': severity,
        'classification': classification,
        'confidence': confidence,
        'heelStrikeCount': heelStrikeCount,
        'toeOffCount': toeOffCount,
        'semiogram': semiogram.toJson(),
      };

  factory GaitResult.fromJson(Map<String, dynamic> json) => GaitResult(
        fmaLeScore: json['fmaLeScore'] as int,
        severity: json['severity'] as String,
        classification: json['classification'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        heelStrikeCount: json['heelStrikeCount'] as int,
        toeOffCount: json['toeOffCount'] as int,
        semiogram: SemiogramResult.fromJson(
            json['semiogram'] as Map<String, dynamic>),
      );
}
