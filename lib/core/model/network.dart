class Network {
  final String? id;
  final String? name;
  final String? wallet;

  Network({
    this.id,
    this.name,
    this.wallet,
  });

  factory Network.fromMap(Map<String, dynamic> map) {
    return Network(
        id: map['id'], name: map["name"], wallet: map["wallet_address"]);
  }
}
