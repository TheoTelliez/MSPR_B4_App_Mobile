class JwtResponse {
  late String token;

  JwtResponse(
      {required this.token});

  Map<String, dynamic> toMap() {
    return {
      'token': token,
    };
  }

  JwtResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
  JwtResponse.tojwt(Map<String, dynamic> json, String token) {
    token = token;
  }
}
