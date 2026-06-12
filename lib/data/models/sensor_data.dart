class SensorData {
  final int timestamp;
  final double accX;
  final double accY;
  final double accZ;
  final double gyrX;
  final double gyrY;
  final double gyrZ;
  final String footSide;

  const SensorData({
    required this.timestamp,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyrX,
    required this.gyrY,
    required this.gyrZ,
    required this.footSide,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'accX': accX,
        'accY': accY,
        'accZ': accZ,
        'gyrX': gyrX,
        'gyrY': gyrY,
        'gyrZ': gyrZ,
        'footSide': footSide,
      };

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        timestamp: json['timestamp'] as int,
        accX: (json['accX'] as num).toDouble(),
        accY: (json['accY'] as num).toDouble(),
        accZ: (json['accZ'] as num).toDouble(),
        gyrX: (json['gyrX'] as num).toDouble(),
        gyrY: (json['gyrY'] as num).toDouble(),
        gyrZ: (json['gyrZ'] as num).toDouble(),
        footSide: json['footSide'] as String,
      );
}
