
class DashboardData{
  final int? status;
  final List<dynamic> data;


  const DashboardData({required this.status,required this.data});

  factory DashboardData.fromJson(Map<String, dynamic> json){
    return DashboardData(
      status: json['status'],
      data: json['data'],
    );
  }
}