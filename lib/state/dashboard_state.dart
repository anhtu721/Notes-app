
import 'package:notes_app/model/dashboard_data.dart';

abstract class DashboardState {}

class InitialDashboardState extends DashboardState {}

class LoadingDashboardState extends DashboardState {}

class FailureDashboardState extends DashboardState {
  final String errorMessage;
  FailureDashboardState(this.errorMessage);
}

class SuccessLoadAllDashboardState extends DashboardState {
  final DashboardData dashboardData;
  SuccessLoadAllDashboardState(this.dashboardData);
}

