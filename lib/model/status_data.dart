
class StatusData{
  final int? status;
  final List<dynamic> data;


  const StatusData({required this.status,required this.data});

  factory StatusData.fromJson(Map<String, dynamic> json){
    return StatusData(
      status: json['status'],
      data: json['data'],
    );
  }
}
