class TsItemDTO {
  final int id;
  final String? taskName;
  final String? projectTitle;
  final String? description;
  final String? workTypeName;
  final String? timeGap;
  final String? dateCreate;
  final int? timeDuration;

  TsItemDTO({
    required this.id,
    required this.taskName,
    required this.projectTitle,
    required this.description,
    required this.workTypeName,
    required this.timeGap,
    required this.dateCreate,
    required this.timeDuration,
  });

  factory TsItemDTO.fromJson(Map<String, dynamic> json) => TsItemDTO(
        id: json['id'],
        timeDuration: json['timeDuration'],
        taskName: json['taskName'],
        projectTitle: json['title'],
        description: json['subTitle'],
        workTypeName: json['workTypeName'],
        timeGap: json['timeGap'],
        dateCreate: json['dateCreate'],
      );
}
