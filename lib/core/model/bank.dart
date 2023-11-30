class Bank {
  final String? id;
  final String? name;

  Bank({this.id, this.name});

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      id: map['id'],
      name: map['name'],
    );
  }
}
