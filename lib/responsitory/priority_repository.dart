import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/model/priority_data.dart';
import 'package:notes_app/until/constances.dart';

class PriorityRepository {
  // Get all PriorityData
  Future<PriorityData> getAllPriority(String email) async {
    final String url = "${Constance.baseUrl}get?tab=Priority&email=$email";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return PriorityData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load Priority data ${response.statusCode}');
  }

//Create PriorityData
  Future<PriorityData> createPriority(List body) async {
    final String url =
        "${Constance.baseUrl}add?tab=Priority&email=${body[0]}&name=${body[1]}";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return PriorityData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to create Status data ${response.statusCode}');
  }

//Delete PriorityData
  Future<PriorityData> deletePriority(String email, String name) async {
    final String url =
        "${Constance.baseUrl}/del?tab=Priority&email=$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return PriorityData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to delete Priority data ${response.statusCode}');
  }

//Edit PriorityData
  Future<PriorityData> editPriority(List body) async {
    final String url =
        "${Constance.baseUrl}/update?tab=Priority&email=${body[0]}&name=${body[1]}&nname=${body[2]}";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return PriorityData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to delete Priority data ${response.statusCode}');
  }
}
