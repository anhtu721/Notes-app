import 'package:notes_app/model/priority_data.dart';


abstract class PriorityState {}

class InitialPriorityState extends PriorityState {}

class LoadingPriorityState extends PriorityState {}

class FailurePriorityState extends PriorityState {
  final String errorMessage;
  FailurePriorityState(this.errorMessage);
}

class SuccessLoadAllPriorityState extends PriorityState {
  final PriorityData priorityData;
  SuccessLoadAllPriorityState(this.priorityData);
}

class SuccessSubmitPriorityState extends PriorityState {
  final PriorityData priorityData;
  SuccessSubmitPriorityState(this.priorityData);
}

