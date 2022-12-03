import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/model/note_data.dart';
import 'package:notes_app/responsitory/note_repository.dart';
import 'package:notes_app/state/note_state.dart';





//tao class NoteCubit ke thua tu cubit va NoteState
class NoteCubit extends Cubit<NoteState> {
  final NoteRepository _repository;

  NoteCubit(this._repository) : super(InitialNoteState());

  Future<void> getAllNote(String email) async {
    emit(LoadingNoteState());
    try {
      var result = await _repository.getAllNotes(email);
      emit(SuccessLoadAllNoteState(result));
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }
//create
  Future<void> createNotes(DataAddNote dataAddNote) async {
    emit(LoadingNoteState());
    try {
      var result = await _repository.createNotes(dataAddNote);
      emit(SuccessLoadAllNoteState(result));
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }
//update
  Future<void> updateNotes(String oldname, DataAddNote dataAddNote) async {
    emit(LoadingNoteState());
    try {
      var result = await _repository.updateNotes(oldname, dataAddNote);
      emit(SuccessLoadAllNoteState(result));
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }
//delete
  Future<void> deleteNotes(String email, String name) async {
    emit(LoadingNoteState());
    try {
      var result = await _repository.deleteNotes(email, name);
      emit(SuccessLoadAllNoteState(result));
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }
}