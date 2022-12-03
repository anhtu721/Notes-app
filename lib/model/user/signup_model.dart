class SignUpResponse {
  final int? status;
  final int? error;

  const SignUpResponse({
    this.status,
    this.error,
  });
  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      status: json['status'],
      error: json['error'],
    );
  }
}

class SignUpRequest {
  final String? email;
  final String? pass;
  final String? firstname;
  final String? lastname;
  const SignUpRequest({
    this.email,
    this.pass,
    this.firstname,
    this.lastname,
  });
  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      email: json['email'],
      pass: json['pass'],
      firstname: json['FirstName'],
      lastname: json['LastName'],
    );
  }
}
