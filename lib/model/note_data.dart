class NoteData {
  final int? status;
  final int? error;
  final List<dynamic> data;

  const NoteData({this.status, this.error, required this.data});

  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
      status: json['status'],
      error: json['error'],
      data: json['data'],
    );
  }
}

class DataAddNote {
  String? email;
  String? name;
  String? priority;
  String? category;
  String? status;
  String? date;

  DataAddNote(
      {this.email,
      this.name,
      this.priority,
      this.category,
      this.status,
      this.date});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'priority': priority,
      'category': category,
      'status': status,
      'planDate': date,
      'email': email,
    };

    return map;
  }
}
