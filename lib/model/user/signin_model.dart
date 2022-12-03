class SignInResponse {
  final int? status;
  final int? error;
  final Info? info;

  const SignInResponse({
    this.status,
    this.error,
    this.info,
  });
  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      status: json['status'],
      error: json['error'],
      info: json['info'] != null ? Info.fromJson(json['info']) : null,
    );
  }
}

class Info {
  final String? firstName;
  final String? lastName;
  Info({this.firstName, this.lastName});
  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      firstName: json['FirstName'],
      lastName: json['LastName'],
    );
  }
}

class SignInRequest {
  late String? email;
  late String? pass;
  SignInRequest({this.email, this.pass});
  factory SignInRequest.fromJson(Map<String, dynamic> json) {
    return SignInRequest(email: json['email'], pass: json['pass']);
  }
  Map<String, dynamic> toJson() => {
        'email': email,
        'pass': pass,
      };
}
