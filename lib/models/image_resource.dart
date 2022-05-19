class ImageResourceModel {
  String url;
  String? style;

  ImageResourceModel({
    required this.url,
    this.style,
  });

  factory ImageResourceModel.fromJson(Map<String, dynamic> json) {
    return ImageResourceModel(
      url: json['url'] ?? '',
      style: json['style'],
    );
  }
}