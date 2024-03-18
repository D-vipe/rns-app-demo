class CreateEmailBody {
  final String theme;
  // Почта с которой будет уходить письмо
  final int fromMailboxId;
  final String to;
  final String copy;
  final String copyHide;
  final String body;
  final String footer;
  final String? sendDateTime;
  final int? parentIncomingId;
  final int? parentOutgoingId;

  const CreateEmailBody({
    required this.theme,
    required this.fromMailboxId,
    required this.to,
    required this.copy,
    required this.copyHide,
    required this.body,
    required this.footer,
    this.sendDateTime,
    this.parentIncomingId,
    this.parentOutgoingId,
  });

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'fromMailboxId': fromMailboxId,
        'to': to,
        'copy': copy,
        'copyHide': copyHide,
        'body': body,
        'footer': footer,
        if (sendDateTime != null) 'sendDateTime': sendDateTime,
        if (parentIncomingId != null) 'parentIncomingId': parentIncomingId,
        if (parentOutgoingId != null) 'parentOutgoingId': parentOutgoingId,
      };
}
