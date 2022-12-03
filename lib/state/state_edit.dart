import '../model/model_edit.dart';

abstract class EditProfileState {}

class InitialEditProfileState extends EditProfileState {}

class FailureEditProfileState extends EditProfileState {
  final String errorMessage;
  FailureEditProfileState(this.errorMessage);
}

class SuccessEditProfileState extends EditProfileState {
  final EditProfile editProfileData;
  SuccessEditProfileState(this.editProfileData);
}
