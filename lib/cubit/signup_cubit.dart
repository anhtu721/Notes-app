import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/model/user/signup_model.dart';
import 'package:notes_app/responsitory/signup_responsitory.dart';
import 'package:notes_app/state/signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpResponsitory _responsitory;

  SignUpCubit(this._responsitory) : super(InitialSignUpState());

  Future<void> getSignUp(SignUpRequest signUpRequest) async {
    emit(LoadingSignUpState());
    try {
      var result = await _responsitory.getUserSignUp(signUpRequest);
      emit(SuccessfulSignUpState(result));
    } catch (e) {
      emit(FailureSignUpState(e.toString()));
    }
  }
}
