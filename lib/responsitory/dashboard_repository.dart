import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/model/dashboard_data.dart';
import 'package:notes_app/until/constances.dart';

class DashboardRepository {
  Future<DashboardData> getAllDashboard(String email) async {
    final String url = "${Constance.baseUrl}get?tab=Dashboard&email=$email";
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return DashboardData.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load Dashboard data ${response.statusCode}');
  }
}
