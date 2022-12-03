import 'package:notes_app/model/user/signin_model.dart';

abstract class SignInState {}

class InitialSignInState extends SignInState {}

class LoadingSignInState extends SignInState {}

class SuccessfulSignInState extends SignInState {
  final SignInResponse signInResponse;
  SuccessfulSignInState(this.signInResponse);
}

class FailureSignInState extends SignInState {
  final String message;
  FailureSignInState(this.message);
}

class LoadDataState extends SignInState {
  final Info info;
  LoadDataState(this.info);
}
