import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/model/status_data.dart';
import 'package:notes_app/until/constances.dart';

class StatusRepository {
  // Get all StatusData
  Future<StatusData> getAllStatus(String email) async {
    final String url = "${Constance.baseUrl}get?tab=Status&email=$email";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return StatusData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load Status data ${response.statusCode}');
  }

//Create StatusData
  Future<StatusData> createStatus(List body) async {
    final String url =
        "${Constance.baseUrl}add?tab=Status&email=${body[0]}&name=${body[1]}";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return StatusData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to create Status data ${response.statusCode}');
  }

//Delete StatusData
  Future<StatusData> deleteStatus(String email, String name) async {
    final String url =
        "${Constance.baseUrl}/del?tab=Status&email=$email&name=$name";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return StatusData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to delete Status data ${response.statusCode}');
  }

//Edit StatusData
  Future<StatusData> editStatus(List body) async {
    final String url =
        "${Constance.baseUrl}/update?tab=Status&email=${body[0]}&name=${body[1]}&nname=${body[2]}";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return StatusData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to delete Status data ${response.statusCode}');
  }
}
