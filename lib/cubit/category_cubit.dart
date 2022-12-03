
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/responsitory/category_repository.dart';
import 'package:notes_app/state/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(InitialCategoryState());

  Future<void> getAllCategory(String email) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.getAllCategory(email);
      emit(SuccessLoadAllCategoryState(result));
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
  }

  Future<void> createCategory(List body) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.createCategory(body);
      emit(SuccessSubmitCategoryState(result));
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
    getAllCategory(body[0]);
  }

  Future<void> deleteCategory(String email, String name) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.deleteCategory(email, name);
      emit(SuccessSubmitCategoryState(result));
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
    getAllCategory(email);
  }

  Future<void> editCategory(List body) async {
    emit(LoadingCategoryState());
    try {
      var result = await _repository.editCategory(body);
      emit(SuccessSubmitCategoryState(result));
    } catch (e) {
      emit(FailureCategoryState(e.toString()));
    }
    getAllCategory(body[0]);
  }
}
