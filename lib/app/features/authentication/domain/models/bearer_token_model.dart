class BearerToken {
  final String data;
  final String type;
  final DateTime expDate;

  BearerToken({
    required this.data,
    required this.type,
    required this.expDate,
  });

  Map<String, dynamic> toJson() => {
        'data': data,
        'type': type,
        'expDate': expDate.toIso8601String(),
      };

  factory BearerToken.fromJson(Map<String, dynamic> json) => BearerToken(
        data: json['data'],
        type: json['type'],
        expDate: DateTime.parse(json['expDate']),
      );
}
