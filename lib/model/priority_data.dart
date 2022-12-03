
class PriorityData{
  final int? status;
  final List<dynamic> data;


  const PriorityData({required this.status,required this.data});

  factory PriorityData.fromJson(Map<String, dynamic> json){
    return PriorityData(
      status: json['status'],
      data: json['data'],
    );
  }
}
