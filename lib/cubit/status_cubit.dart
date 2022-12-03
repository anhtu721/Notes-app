import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/state/status_state.dart';
import 'package:notes_app/responsitory/status_repository.dart';

class StatusCubit extends Cubit<StatusState> {
  final StatusRepository _repository;

  StatusCubit(this._repository) : super(InitialStatusState());

  Future<void> getAllStatus(String email) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.getAllStatus(email);
      emit(SuccessLoadAllStatusState(result));
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
  }

  Future<void> createStatus(List body) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.createStatus(body);
      emit(SuccessSubmitStatusState(result));
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
    getAllStatus(body[0]);
  }

  Future<void> deleteStatus(String email, String name) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.deleteStatus(email, name);
      emit(SuccessSubmitStatusState(result));
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
    getAllStatus(email);
  }

  Future<void> editStatus(List body) async {
    emit(LoadingStatusState());
    try {
      var result = await _repository.editStatus(body);
      emit(SuccessSubmitStatusState(result));
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
    getAllStatus(body[0]);
  }
}
