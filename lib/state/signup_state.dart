import 'package:notes_app/model/user/signup_model.dart';

abstract class SignUpState {}

class InitialSignUpState extends SignUpState {}

class LoadingSignUpState extends SignUpState {}

class SuccessfulSignUpState extends SignUpState {
  final SignUpResponse signUpResponse;
  SuccessfulSignUpState(this.signUpResponse);
}

class FailureSignUpState extends SignUpState {
  final String message;
  FailureSignUpState(this.message);
}
