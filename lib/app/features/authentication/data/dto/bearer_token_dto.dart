class BearerTokenDTO {
  final String data;
  final String type;
  final int expireIn;

  BearerTokenDTO({
    required this.data,
    required this.type,
    required this.expireIn,
  });

  factory BearerTokenDTO.fromJson(Map<String, dynamic> json) => BearerTokenDTO(
        data: json['access_token'],
        type: json['token_type'],
        expireIn: json['expires_in'] is int ? json['expires_in'] : 59,
      );
}
