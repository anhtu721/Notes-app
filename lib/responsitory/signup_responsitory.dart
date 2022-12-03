import 'dart:convert';
import 'package:notes_app/model/user/signup_model.dart';
import 'package:notes_app/until/constances.dart';
import 'package:http/http.dart' as http;

class SignUpResponsitory {
  // get user sign up
  Future<SignUpResponse> getUserSignUp(SignUpRequest signUpRequest) async {
    final String url =
        '${Constance.baseUrl}signup?email=${signUpRequest.email}&pass=${signUpRequest.pass}&firstname=${signUpRequest.firstname}&lastname=${signUpRequest.lastname}';
    final Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return SignUpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Sign up ${response.statusCode}');
    }
  }
}
