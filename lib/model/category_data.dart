
class CategoryData{
  final int? status;
  final List<dynamic> data;


  const CategoryData({required this.status,required this.data});

  factory CategoryData.fromJson(Map<String, dynamic> json){
    return CategoryData(
      status: json['status'],
      data: json['data'],
    );
  }
}
