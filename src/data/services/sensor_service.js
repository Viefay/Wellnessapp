import { SensorData } from '../models/sensor_data.js';

/**
 * SensorService — placeholder for sensors_plus integration.
 * In production this subscribes to device accelerometer + gyroscope streams.
 * For now generates dummy data to allow the full pipeline to run.
 */
export class SensorService {
  constructor() {
    this.isRecording = false;
    this._data = [];
    this._dummyInterval = null;
  }

  start(footSide) {
    this.isRecording = true;
    this._data = [];
    this._dummyInterval = setInterval(() => {
      this._data.push(this._generateSample(footSide));
    }, 20); // ~50 Hz dummy
  }

  stop() {
    this.isRecording = false;
    clearInterval(this._dummyInterval);
    return [...this._data];
  }

  getData() {
    return [...this._data];
  }

  _generateSample(footSide) {
    const t = Date.now();
    return new SensorData({
      timestamp: t,
      accX: (Math.random() - 0.5) * 2 + 0.1,
      accY: (Math.random() - 0.5) * 2 + 9.8,
      accZ: (Math.random() - 0.5) * 2 + 0.05,
      gyrX: (Math.random() - 0.5) * 0.5,
      gyrY: (Math.random() - 0.5) * 0.5,
      gyrZ: (Math.random() - 0.5) * 0.5,
      footSide,
    });
  }
}

export const sensorService = new SensorService();
