class MessageData {
  MessageData({
    this.title,
    this.body,
  });

  String? title;
  String? body;

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
