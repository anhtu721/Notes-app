import 'package:notes_app/model/status_data.dart';

abstract class StatusState {}

class InitialStatusState extends StatusState {}

class LoadingStatusState extends StatusState {}

class FailureStatusState extends StatusState {
  final String errorMessage;
  FailureStatusState(this.errorMessage);
}

class SuccessLoadAllStatusState extends StatusState {
  final StatusData statusData;
  SuccessLoadAllStatusState(this.statusData);
}

class SuccessSubmitStatusState extends StatusState {
  final StatusData statusData;
  SuccessSubmitStatusState(this.statusData);
}
