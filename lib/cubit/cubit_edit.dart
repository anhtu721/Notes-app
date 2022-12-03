import 'package:flutter_bloc/flutter_bloc.dart';
import '../responsitory/repository_edit.dart';
import '../state/state_edit.dart';

class EditProfileCubit extends Cubit<EditProfileState> {//init EditProfile Cubit
  final EditProfileRepository _repository;

  EditProfileCubit(this._repository) : super(InitialEditProfileState());

  Future<void> updateProfile(String emailCurrent, String emailNew, String firstName, String lastName) async {//! return body from API
    try {
      var result = await _repository.updateProfile(emailCurrent, emailNew, firstName, lastName);//result to save body
      emit(SuccessEditProfileState(result));
    } catch (e) {
      emit(FailureEditProfileState(e.toString()));
    }
  }

}