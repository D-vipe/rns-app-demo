class GetFormDataBody {
  final String projectId;

  const GetFormDataBody({required this.projectId});

  Map<String, dynamic> toJson() => {
    'projectId': projectId
  };
}
