import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/model/category_data.dart';
import 'package:notes_app/until/constances.dart';

class CategoryRepository {
  // Get all CategoryData
  Future<CategoryData> getAllCategory(String email) async {
    final String url = "${Constance.baseUrl}get?tab=Category&email=$email";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return CategoryData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load Category data ${response.statusCode}');
  }

//Create CategoryData
  Future<CategoryData> createCategory(List body) async {
    final String url =
        "${Constance.baseUrl}/add?tab=Category&email=${body[0]}&name=${body[1]}";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return CategoryData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to create Category data ${response.statusCode}');
  }

//Delete CategoryData
  Future<CategoryData> deleteCategory(String email, String name) async {
    final String url =
        "${Constance.baseUrl}/del?tab=Category&email=$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return CategoryData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to delete Category data ${response.statusCode}');
  }

//Edit CategoryData
  Future<CategoryData> editCategory(List body) async {
    final String url =
        "${Constance.baseUrl}/update?tab=Category&email=${body[0]}&name=${body[1]}&nname=${body[2]}";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return CategoryData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to delete Category data ${response.statusCode}');
  }
}
