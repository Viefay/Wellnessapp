import 'semiogram_result.dart';

/// One reference parameter from the semiogram journal
/// ("article semiogram.pdf"): population Mean / SD plus the Z-coefficient
/// sign (`+` = higher value is better, `-` = lower value is better).
class SemiogramParam {
  final String criteria;
  final String name;
  final String unit;
  final double mean;
  final double sd;
  final bool positiveIsGood; // true => '+', false => '-'

  const SemiogramParam({
    required this.criteria,
    required this.name,
    required this.unit,
    required this.mean,
    required this.sd,
    required this.positiveIsGood,
  });

  String get zSign => positiveIsGood ? '+' : '-';
}

/// A reference parameter combined with this subject's value and Z-score.
class SemiogramScore {
  final SemiogramParam param;
  final double value;

  const SemiogramScore({required this.param, required this.value});

  /// Standardised score: (value - mean) / SD.
  double get z => param.sd == 0 ? 0 : (value - param.mean) / param.sd;

  /// Z oriented so that a positive number is always clinically favourable.
  double get favourableZ => param.positiveIsGood ? z : -z;

  bool get isFavourable => favourableZ >= 0;
}

/// Full reference table reproduced from the semiogram journal.
const List<SemiogramParam> semiogramReference = [
  SemiogramParam(
      criteria: 'Average speed',
      name: 'V',
      unit: 'm/s',
      mean: 1.22,
      sd: 0.20,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Springiness',
      name: 'StrT',
      unit: 's',
      mean: 1.10,
      sd: 0.09,
      positiveIsGood: false),
  SemiogramParam(
      criteria: 'Springiness',
      name: 'UtrT',
      unit: 's',
      mean: 2.62,
      sd: 0.75,
      positiveIsGood: false),
  SemiogramParam(
      criteria: 'Smoothness',
      name: 'LDLJ_A',
      unit: '-',
      mean: -9.07,
      sd: 0.35,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Smoothness',
      name: 'SPARC_acc',
      unit: '-',
      mean: -4.18,
      sd: 0.89,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Steadiness',
      name: 'CVStrT',
      unit: '%',
      mean: 2.34,
      sd: 0.97,
      positiveIsGood: false),
  SemiogramParam(
      criteria: 'Steadiness',
      name: 'CVdsT',
      unit: '%',
      mean: 5.63,
      sd: 2.07,
      positiveIsGood: false),
  SemiogramParam(
      criteria: 'Steadiness',
      name: 'P_Lacc',
      unit: '-',
      mean: 0.82,
      sd: 0.10,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Steadiness',
      name: 'P_Zacc',
      unit: '-',
      mean: 0.82,
      sd: 0.10,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Sturdiness',
      name: 'StL',
      unit: 'm',
      mean: 0.68,
      sd: 0.08,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Stability',
      name: 'RMS_ML',
      unit: 'm/s²',
      mean: 1.28,
      sd: 0.33,
      positiveIsGood: false),
  SemiogramParam(
      criteria: 'Symmetry',
      name: 'dlR_acc (AP)',
      unit: '%',
      mean: 95.48,
      sd: 2.13,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Symmetry',
      name: 'dlR_acc (ML)',
      unit: '%',
      mean: 94.88,
      sd: 3.10,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Symmetry',
      name: 'dlR_acc (V)',
      unit: '%',
      mean: 86.77,
      sd: 6.32,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Symmetry',
      name: 'P1P1_acc',
      unit: '-',
      mean: 0.96,
      sd: 0.04,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Symmetry',
      name: 'ewT_c',
      unit: '-',
      mean: 0.96,
      sd: 0.03,
      positiveIsGood: true),
  SemiogramParam(
      criteria: 'Synchronization',
      name: 'defT',
      unit: '%',
      mean: 23.34,
      sd: 3.50,
      positiveIsGood: false),
];

/// Builds the full set of subject scores for the reference table.
///
/// ML inference is out of scope for now, so the per-parameter subject value
/// is derived deterministically from the session's overall semiogram health
/// (`symmetryIndex`, 0..1). A healthier session shifts every parameter in its
/// clinically favourable direction. Replace [SemiogramResult] mapping with
/// real model outputs once the analysis backend is wired.
List<SemiogramScore> buildSemiogramScores(SemiogramResult s) {
  final health = s.symmetryIndex.clamp(0.0, 1.0); // 0 = poor, 1 = excellent
  final deviation = (health - 0.5) * 2.0; // -1 .. 1
  return semiogramReference.map((p) {
    final dir = p.positiveIsGood ? 1.0 : -1.0;
    final value = p.mean + dir * deviation * p.sd;
    return SemiogramScore(param: p, value: value);
  }).toList();
}
