class AppNotification {
  final String? id;
  final String? type;
  final String? notifiable_type;
  final Map<String, dynamic>? data;
  final String? read_at;
  final String? created_at;
  final String? updated_at;

  AppNotification({
    this.id,
    this.type,
    this.notifiable_type,
    this.data,
    this.read_at,
    this.created_at,
    this.updated_at,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map["id"],
      type: map["type"],
      notifiable_type: map["notifiable_type"],
      data: map["data"],
      read_at: map["read_at"],
      created_at: map["created_at"],
      updated_at: map["updated_at"],
    );
  }
}
