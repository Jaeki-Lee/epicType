class ContentFile {
  final String category;
  final List<ContentItem> items;

  ContentFile({required this.category, required this.items});

  factory ContentFile.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List<dynamic>? ?? [];
    List<ContentItem> itemList = itemsJson
        .map((item) => ContentItem.fromJson(item))
        .toList();

    return ContentFile(category: json['category'] ?? '', items: itemList);
  }
}

class ContentItem {
  final String id;
  final String textEn;
  final String textKo;
  final String work;
  final String author;
  final bool allowLinebreaks;

  ContentItem({
    required this.id,
    required this.textEn,
    required this.textKo,
    required this.work,
    required this.author,
    required this.allowLinebreaks,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] ?? '',
      textEn: json['text_en'] ?? '',
      textKo: json['text_ko'] ?? '',
      work: json['work'] ?? '',
      author: json['author'] ?? '',
      allowLinebreaks: json['allow_linebreaks'] ?? false,
    );
  }
}
