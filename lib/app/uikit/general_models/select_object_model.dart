class SelectObject {
  final String id;
  final String title;
  final bool? isChecked;

  SelectObject({
    required this.id,
    required this.title,
    this.isChecked,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectObject && runtimeType == other.runtimeType && id == other.id && title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
