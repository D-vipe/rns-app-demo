part of 'api_endpoints.dart';

class EmailEndpoints {
  EmailEndpoints._();

  static const String listIncoming = '/api/Email/Incoming';
  static const String listOutgoing = '/api/Email/Outgoing';
  static const String viewIncoming = '/api/Email/ViewIncoming';
  static const String viewOutgoing = '/api/Email/ViewOutgoing';
  static const String personalMailBoxes = '/api/Email/MailBoxes';
  static const String otherMailBoxes = '/api/Email/MailBoxesEmployees';
  static const String sendEmail = '/api/Email/Create';
  static const String changeImportance = '/api/Email/EditImportanceIncoming';
  static const String deleteIncoming = '/api/Email/deleteIncoming';
  static const String deleteIncomingMulti = '/api/Email/deleteIncomingMulti';
  static const String deleteOutgoing = '/api/Email/deleteOutgoing';
  static const String deleteOutgoingMulti = '/api/Email/deleteOutgoingMulti';
  static const String markRead = '/api/Email/read';
  static const String markBatchRead = '/api/Email/readMulti';
  static const String markUnread = '/api/Email/unread';
  static const String markBatchUnread = '/api/Email/unreadMulti';
}
