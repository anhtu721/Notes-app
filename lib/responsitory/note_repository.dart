import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/model/note_data.dart';
import 'package:notes_app/until/constances.dart';

class NoteRepository {
  // Get all profile
  Future<NoteData> getAllNotes(String email) async {
    final String url = "${Constance.baseUrl}/get/?tab=Note&email=$email";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == Constance.statusCode200) {
      return NoteData.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load Profile data ${response.statusCode}');
  }

//Create a Profile
  Future<NoteData> createNotes(DataAddNote dataAddNote) async {
    String url = '${Constance.baseUrl}add?tab=Note'
        '&email=${dataAddNote.email}'
        '&name=${dataAddNote.name}'
        '&Priority=${dataAddNote.priority}'
        '&Category=${dataAddNote.category}'
        '&Status=${dataAddNote.status}'
        '&PlanDate=${dataAddNote.date}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == Constance.statusCode200) {
      return NoteData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create note ${response.statusCode}');
    }
  }

  //Update
  Future<NoteData> updateNotes(String oldname, DataAddNote dataAddNote) async {
    String url = '${Constance.baseUrl}update?tab=Note'
        '&email=${dataAddNote.email}'
        '&name=$oldname'
        '&nname=${dataAddNote.name}'
        '&Priority=${dataAddNote.priority}'
        '&Category=${dataAddNote.category}'
        '&Status=${dataAddNote.status}'
        '&PlanDate=${dataAddNote.date}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == Constance.statusCode200) {
      return NoteData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update note ${response.statusCode}');
    }
  }

  //Delete
  Future<NoteData> deleteNotes(String email, String name) async {
    String url = '${Constance.baseUrl}del?tab=Note'
        '&email=$email'
        '&name=$name';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == Constance.statusCode200) {
      return NoteData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete note ${response.statusCode}');
    }
  }
}
