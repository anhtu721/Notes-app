import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/state/dashboard_state.dart';
import 'package:notes_app/responsitory/dashboard_repository.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;

  DashboardCubit(this._repository) : super(InitialDashboardState());

  Future<void> getAllDashboard(String email) async {
    emit(LoadingDashboardState());
    try {
      var result = await _repository.getAllDashboard(email);
      emit(SuccessLoadAllDashboardState(result));
    } catch (e) {
      emit(FailureDashboardState(e.toString()));
    }
  }

}