import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/until/constances.dart';
import '../model/model_edit.dart';

class EditProfileRepository {
  Future<EditProfile> updateProfile(String emailCurrent, String emailNew,
      String firstName, String lastName) async {
    //process press Edit
    final url = '${Constance.baseUrl}update?tab=Profile'
        '&email=$emailCurrent'
        '&nemail=$emailNew'
        '&firstname=$firstName'
        '&lastname=$lastName';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return EditProfile.fromJson(jsonDecode(response.body)); //return 1 obj
    } else {
      throw Exception('Failed to update profile ${response.statusCode}');
    }
  }
}
