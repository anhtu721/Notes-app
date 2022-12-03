import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/model/user/signin_model.dart';
import 'package:notes_app/responsitory/signin_responsitory.dart';
import 'package:notes_app/state/signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInResponsitory _responsitory;

  SignInCubit(this._responsitory) : super(InitialSignInState());

  Future<void> getSignIn(SignInRequest signInRequest) async {
    emit(LoadingSignInState());
    try {
      var result = await _responsitory.getUserSignIn(signInRequest);
      emit(SuccessfulSignInState(result));
    } catch (e) {
      emit(FailureSignInState(e.toString()));
    }
  }
}
