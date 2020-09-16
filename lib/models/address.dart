class Address {
  int userId;
  int id;
  String title;
  String body;

  Address({this.userId, this.id, this.title, this.body});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      userId: json["userId"] as int,
      id: json["id"] as int,
      title: json["title"] as String,
      body: json["body"] as String,
    );
  }

  @override
  String toString() {
    return '{ ${this.userId}, ${this.id}, ${this.title}, ${this.body} }';
  }
}