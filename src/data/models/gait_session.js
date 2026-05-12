import { GaitResult } from './gait_result.js';

export class GaitSession {
  constructor({ id, date, footSide, result, sensorData = [] }) {
    this.id = id;
    this.date = date;
    this.footSide = footSide;
    this.result = result instanceof GaitResult ? result : new GaitResult(result);
    this.sensorData = sensorData;
  }

  toJson() {
    return {
      id: this.id,
      date: this.date,
      footSide: this.footSide,
      result: this.result.toJson(),
      sensorData: this.sensorData.map(s => s.toJson ? s.toJson() : s),
    };
  }

  static fromJson(json) { return new GaitSession(json); }
}
