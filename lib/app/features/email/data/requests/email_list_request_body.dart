import 'package:intl/intl.dart';

class EmailListRequestBody {
  final String? recipientId;
  final int? mailboxId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? importance;
  final String searchTerm;
  final bool? onlyUnread;
  final int pageSize;
  final int numPage;

  const EmailListRequestBody({
    required this.recipientId,
    required this.mailboxId,
    required this.dateFrom,
    required this.dateTo,
    required this.importance,
    required this.searchTerm,
    required this.onlyUnread,
    required this.pageSize,
    required this.numPage,
  });

  Map<String, dynamic> toJson() => {
        if (recipientId != null) 'recipient': recipientId,
        'mailboxId': mailboxId,
        'dateFrom': dateFrom != null ? DateFormat('yyyy-MM-dd').format(dateFrom!) : null,
        'dateTo': dateTo != null ? DateFormat('yyyy-MM-dd').format(dateTo!) : null,
        'onlyUnRead': onlyUnread,
        if (importance != null) 'importance': importance,
        'searchTerm': searchTerm,
        'pageSize': pageSize,
        'numPage': numPage,
      };
}
