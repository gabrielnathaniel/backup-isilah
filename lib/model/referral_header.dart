class HeaderReferral {
  HeaderReferral({
    this.refferalCode,
    this.totalRefferal,
    this.totalRefferalValid,
  });

  String? refferalCode;
  int? totalRefferal;
  int? totalRefferalValid;

  factory HeaderReferral.fromJson(Map<String, dynamic> json) => HeaderReferral(
        refferalCode: json["refferal_code"],
        totalRefferal: json["total_refferal"],
        totalRefferalValid: json["total_refferal_valid"],
      );

  Map<String, dynamic> toJson() => {
        "refferal_code": refferalCode,
        "total_refferal": totalRefferal,
        "total_refferal_valid": totalRefferalValid,
      };
}
