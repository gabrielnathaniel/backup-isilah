class UserId {
  UserId({
    this.id,
  });

  int? id;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
