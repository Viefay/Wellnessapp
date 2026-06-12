export class SemiogramResult {
  constructor({ V, StrT, UtrT, LDLJa, SPARCrot, CVStrT, CVdstT, P1acc, P2acc, SteL, RMSaML, iHRaAP, iHRaCC, iHRaML, P1P2acc, swTr, dstT }) {
    this.V = V;
    this.StrT = StrT;
    this.UtrT = UtrT;
    this.LDLJa = LDLJa;
    this.SPARCrot = SPARCrot;
    this.CVStrT = CVStrT;
    this.CVdstT = CVdstT;
    this.P1acc = P1acc;
    this.P2acc = P2acc;
    this.SteL = SteL;
    this.RMSaML = RMSaML;
    this.iHRaAP = iHRaAP;
    this.iHRaCC = iHRaCC;
    this.iHRaML = iHRaML;
    this.P1P2acc = P1P2acc;
    this.swTr = swTr;
    this.dstT = dstT;
  }

  toJson() { return { ...this }; }
  static fromJson(json) { return new SemiogramResult(json); }
}
