class SemiogramResult {
  final double v; // Average Speed (m/s)
  final double strT; // Springiness
  final double utrT; // Upper Trunk Range
  final double ldlja; // Smoothness (log dimensionless jerk)
  final double sparcrot; // SPARC rotation
  final double sparctra; // SPARC translation
  final double sparcver; // SPARC vertical
  final double mdifAP; // Mean diff AP
  final double mdifML; // Mean diff ML
  final double cvStrideTime; // CV stride time
  final double cvStrideLength; // CV stride length
  final double symmetryIndex; // Symmetry index
  final double stepLengthLeft;
  final double stepLengthRight;
  final double stanceLeft; // % stance phase left
  final double stanceRight; // % stance phase right
  final double cadence; // steps/min

  const SemiogramResult({
    required this.v,
    required this.strT,
    required this.utrT,
    required this.ldlja,
    required this.sparcrot,
    required this.sparctra,
    required this.sparcver,
    required this.mdifAP,
    required this.mdifML,
    required this.cvStrideTime,
    required this.cvStrideLength,
    required this.symmetryIndex,
    required this.stepLengthLeft,
    required this.stepLengthRight,
    required this.stanceLeft,
    required this.stanceRight,
    required this.cadence,
  });

  Map<String, dynamic> toJson() => {
        'v': v,
        'strT': strT,
        'utrT': utrT,
        'ldlja': ldlja,
        'sparcrot': sparcrot,
        'sparctra': sparctra,
        'sparcver': sparcver,
        'mdifAP': mdifAP,
        'mdifML': mdifML,
        'cvStrideTime': cvStrideTime,
        'cvStrideLength': cvStrideLength,
        'symmetryIndex': symmetryIndex,
        'stepLengthLeft': stepLengthLeft,
        'stepLengthRight': stepLengthRight,
        'stanceLeft': stanceLeft,
        'stanceRight': stanceRight,
        'cadence': cadence,
      };

  factory SemiogramResult.fromJson(Map<String, dynamic> json) => SemiogramResult(
        v: (json['v'] as num).toDouble(),
        strT: (json['strT'] as num).toDouble(),
        utrT: (json['utrT'] as num).toDouble(),
        ldlja: (json['ldlja'] as num).toDouble(),
        sparcrot: (json['sparcrot'] as num).toDouble(),
        sparctra: (json['sparctra'] as num).toDouble(),
        sparcver: (json['sparcver'] as num).toDouble(),
        mdifAP: (json['mdifAP'] as num).toDouble(),
        mdifML: (json['mdifML'] as num).toDouble(),
        cvStrideTime: (json['cvStrideTime'] as num).toDouble(),
        cvStrideLength: (json['cvStrideLength'] as num).toDouble(),
        symmetryIndex: (json['symmetryIndex'] as num).toDouble(),
        stepLengthLeft: (json['stepLengthLeft'] as num).toDouble(),
        stepLengthRight: (json['stepLengthRight'] as num).toDouble(),
        stanceLeft: (json['stanceLeft'] as num).toDouble(),
        stanceRight: (json['stanceRight'] as num).toDouble(),
        cadence: (json['cadence'] as num).toDouble(),
      );
}
