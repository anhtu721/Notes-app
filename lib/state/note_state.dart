import 'package:notes_app/model/note_data.dart';

abstract class NoteState {}

class InitialNoteState extends NoteState {}

class LoadingNoteState extends NoteState {}

class FailureNoteState extends NoteState {
  final String errorMessage;
  FailureNoteState(this.errorMessage);
}

class FailureDeleteNoteState extends NoteState {
  final String errorMessage;

  FailureDeleteNoteState(this.errorMessage);
}

class SuccessLoadAllNoteState extends NoteState {
  final NoteData listNote;
  SuccessLoadAllNoteState(this.listNote);
}

class SuccessSubmitNoteState extends NoteState {
  final NoteData noteData;
  SuccessSubmitNoteState(this.noteData);
}
