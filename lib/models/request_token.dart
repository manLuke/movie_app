class RequestToken {
  final String requestToken;
  final String expiresAt;
  final bool success;

  RequestToken({
    required this.requestToken,
    required this.expiresAt,
    required this.success,
  });

  factory RequestToken.fromJson(Map<String, dynamic> json) {
    return RequestToken(
      requestToken: json['request_token'],
      expiresAt: json['expires_at'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_token': requestToken,
      'expires_at': expiresAt,
      'success': success,
    };
  }
}
