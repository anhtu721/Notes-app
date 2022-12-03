import 'package:flutter_bloc/flutter_bloc.dart';
import '../responsitory/repository_change.dart';
import '../state/state_change.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {//init ChangePassword Cubit
  final ChangePasswordRepository _repository;

  ChangePasswordCubit(this._repository) : super(InitialChangePasswordState());

  Future<void> updatePassword(String emailCurrent, String passCurrent, String passNew) async {//! return body from API
    try {
      var result = await _repository.updatePassword(emailCurrent,passCurrent,passNew );//result to save body
      emit(SuccessChangePasswordState(result));
    } catch (e) {
      emit(FailureChangePasswordState(e.toString()));
    }
  }

}