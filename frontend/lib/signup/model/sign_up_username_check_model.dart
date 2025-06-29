class UsernameCheckResponse {
  final bool available;

  UsernameCheckResponse({required this.available});

  factory UsernameCheckResponse.fromJson(Map<String, dynamic> json) {
    return UsernameCheckResponse(available: json['data'] as bool);
  }
}