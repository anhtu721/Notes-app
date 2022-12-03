
import 'package:notes_app/model/category_data.dart';

abstract class CategoryState {}

class InitialCategoryState extends CategoryState {}

class LoadingCategoryState extends CategoryState {}

class FailureCategoryState extends CategoryState {
  final String errorMessage;
  FailureCategoryState(this.errorMessage);
}

class SuccessLoadAllCategoryState extends CategoryState {
  final CategoryData categoryData;
  SuccessLoadAllCategoryState(this.categoryData);
}

class SuccessSubmitCategoryState extends CategoryState {
  final CategoryData categoryData;
  SuccessSubmitCategoryState(this.categoryData);
}
