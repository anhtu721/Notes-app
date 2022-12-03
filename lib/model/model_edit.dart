class EditProfile {
  final int? status;

  const EditProfile({required this.status});//constructor

  factory EditProfile.fromJson(Map<String, dynamic> json) {
    return EditProfile(status: json['status']);
  }
}