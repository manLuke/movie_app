class AccountDetails {
  final int id;
  final String username;
  final String avatarHash;

  AccountDetails({
    required this.id,
    required this.username,
    required this.avatarHash,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) {
    return AccountDetails(
      id: json['id'],
      username: json['username'],
      avatarHash: json['avatar']['gravatar']['hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': {
        'gravatar': {
          'hash': avatarHash,
        },
      },
    };
  }
}
