import { SemiogramResult } from './semiogram_result.js';

export class GaitResult {
  constructor({ fmaLeScore, severity, classification, confidence, heelStrikeCount, toeOffCount, semiogram }) {
    this.fmaLeScore = fmaLeScore;
    this.severity = severity;
    this.classification = classification;
    this.confidence = confidence;
    this.heelStrikeCount = heelStrikeCount;
    this.toeOffCount = toeOffCount;
    this.semiogram = semiogram instanceof SemiogramResult ? semiogram : new SemiogramResult(semiogram);
  }

  toJson() {
    return {
      fmaLeScore: this.fmaLeScore,
      severity: this.severity,
      classification: this.classification,
      confidence: this.confidence,
      heelStrikeCount: this.heelStrikeCount,
      toeOffCount: this.toeOffCount,
      semiogram: this.semiogram.toJson(),
    };
  }

  static fromJson(json) { return new GaitResult(json); }
}
