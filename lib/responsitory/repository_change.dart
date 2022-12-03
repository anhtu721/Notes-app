import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/until/constances.dart';
import '../model/model_change.dart';

class ChangePasswordRepository {
  Future<ChangePassword> updatePassword(
      String emailCurrent, String passCurrent, String passNew) async {
    final url = '${Constance.baseUrl}update?tab=Profile'
        '&email=$emailCurrent'
        '&pass=$passCurrent'
        '&npass=$passNew';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return ChangePassword.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update password ${response.statusCode}');
    }
  }
}
