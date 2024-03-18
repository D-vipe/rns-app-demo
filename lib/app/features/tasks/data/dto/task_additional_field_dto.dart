class TaskAdditionalFieldDTO {
  final int id;
  final String name;
  final bool isObligatory;

  const TaskAdditionalFieldDTO({
    required this.id,
    required this.name,
    required this.isObligatory,
  });

  factory TaskAdditionalFieldDTO.fromJson(Map<String, dynamic> json) => TaskAdditionalFieldDTO(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        isObligatory: json['isObligatory'] ?? false,
      );
}
