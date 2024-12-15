class Session {
  final String sessionId;
  final bool success;

  Session({
    required this.sessionId,
    required this.success,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'success': success,
    };
  }
}
