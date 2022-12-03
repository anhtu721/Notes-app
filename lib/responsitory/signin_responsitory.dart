import 'dart:convert';

import 'package:notes_app/model/user/signin_model.dart';
import 'package:notes_app/until/constances.dart';
import 'package:http/http.dart' as http;

class SignInResponsitory {
  // Get user sign in
  Future<SignInResponse> getUserSignIn(SignInRequest signInRequest) async {
    final String url =
        '${Constance.baseUrl}login?email=${signInRequest.email}&pass=${signInRequest.pass}';
    final Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return SignInResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to sign in ${response.statusCode}');
    }
  }
}
