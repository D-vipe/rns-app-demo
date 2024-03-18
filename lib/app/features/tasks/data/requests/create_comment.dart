class NewCommentRequest {
  final int taskId;
  final String comment;

  const NewCommentRequest({
    required this.taskId,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'objectId': taskId,
        'isPrivate': true,
        'brief': comment,
      };
}
