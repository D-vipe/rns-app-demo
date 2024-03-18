class DirectionDTO {
  final String text;
  final bool isHeader;

  const DirectionDTO({
    required this.text,
    required this.isHeader,
  });

  factory DirectionDTO.fromJson(Map<String, dynamic> json) => DirectionDTO(
        text: json['text'],
        isHeader: json['isHeader'],
      );
}
