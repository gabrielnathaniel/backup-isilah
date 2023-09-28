class ReferralLinkPage {
  ReferralLinkPage({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory ReferralLinkPage.fromJson(Map<String, dynamic> json) =>
      ReferralLinkPage(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
