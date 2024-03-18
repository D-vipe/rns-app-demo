class SelectObjectDTO {
  final String id;
  final String title;
  final bool isChecked;

  SelectObjectDTO({
    required this.id,
    required this.title,
    required this.isChecked,
  });

  factory SelectObjectDTO.fromJson(Map<String, dynamic> json) => SelectObjectDTO(
        id: json['id'] ?? '0',
        title: json['title'] ?? '',
        isChecked: json['isChecked'] ?? false,
      );
}
