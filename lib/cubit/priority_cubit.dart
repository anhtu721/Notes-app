import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/responsitory/priority_repository.dart';
import 'package:notes_app/state/priority_state.dart';

class PriorityCubit extends Cubit<PriorityState> {
  final PriorityRepository _repository;

  PriorityCubit(this._repository) : super(InitialPriorityState());

  Future<void> getAllPriority(String email) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.getAllPriority(email);
      emit(SuccessLoadAllPriorityState(result));
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
  }

  Future<void> createPriority(List body) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.createPriority(body);
      emit(SuccessSubmitPriorityState(result));
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
    getAllPriority(body[0]);
  }

  Future<void> deletePriority(String email, String name) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.deletePriority(email, name);
      emit(SuccessSubmitPriorityState(result));
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
    getAllPriority(email);
  }

  Future<void> editPriority(List body) async {
    emit(LoadingPriorityState());
    try {
      var result = await _repository.editPriority(body);
      emit(SuccessSubmitPriorityState(result));
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
    getAllPriority(body[0]);
  }
}
