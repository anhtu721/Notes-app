import '../model/model_change.dart';

abstract class ChangePasswordState {}

class InitialChangePasswordState extends ChangePasswordState {}

class FailureChangePasswordState extends ChangePasswordState {
  final String errorMessage;
  FailureChangePasswordState(this.errorMessage);
}

class SuccessChangePasswordState extends ChangePasswordState {
  final ChangePassword changePasswordData;
  SuccessChangePasswordState(this.changePasswordData);
}
