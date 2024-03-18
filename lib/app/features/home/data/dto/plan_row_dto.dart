class PlanRowDTO {
  final int projectId;
  final String projectName;
  // в минутах
  final int countPlan;
  final int countFact;
  final String comment;

  const PlanRowDTO(
      {required this.projectId,
      required this.projectName,
      required this.countPlan,
      required this.countFact,
      required this.comment});

  factory PlanRowDTO.fromJson(Map<String, dynamic> json) => PlanRowDTO(
        projectId:json['projectId'] ?? 0,
        projectName:json['projectName'] ?? '',
        countPlan:json['countPlan'] ?? 0,
        countFact:json['countCact'] ?? 0,
        comment:json['comment'] ?? '',
      );
}
