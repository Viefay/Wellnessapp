export class SensorData {
  constructor({ timestamp, accX, accY, accZ, gyrX, gyrY, gyrZ, footSide }) {
    this.timestamp = timestamp;
    this.accX = accX;
    this.accY = accY;
    this.accZ = accZ;
    this.gyrX = gyrX;
    this.gyrY = gyrY;
    this.gyrZ = gyrZ;
    this.footSide = footSide;
  }

  toJson() {
    return {
      timestamp: this.timestamp,
      accX: this.accX,
      accY: this.accY,
      accZ: this.accZ,
      gyrX: this.gyrX,
      gyrY: this.gyrY,
      gyrZ: this.gyrZ,
      footSide: this.footSide,
    };
  }

  static fromJson(json) {
    return new SensorData(json);
  }
}
