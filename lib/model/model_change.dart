class ChangePassword {
  final int? status;

  const ChangePassword({required this.status});//constructor

  factory ChangePassword.fromJson(Map<String, dynamic> json) {
    return ChangePassword(status: json['status']);
  }
}