class Banners {
  final String id;
  final String preview_image;
  final String featured_image;

  Banners({
    required this.id,
    required this.preview_image,
    required this.featured_image,
  });

  factory Banners.fromMap(Map<String, dynamic> map) {
    return Banners(
      id: map['id'],
      preview_image: map["preview_image"],
      featured_image: map["featured_image"],
    );
  }
}
