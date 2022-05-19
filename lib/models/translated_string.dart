class TranslatedStringModel {
  String textRo;
  String textEn;
  String? style;

  TranslatedStringModel({
    required this.textRo,
    required this.textEn,
    this.style,
  });

  factory TranslatedStringModel.fromJson(Map<String, dynamic> json) {
    return TranslatedStringModel(
      textRo: json['text']['ro'] ?? '',
      textEn: json['text']['en'] ?? '',
      style: json['style'],
    );
  }
}