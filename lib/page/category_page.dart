import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/category_cubit.dart';
import 'package:notes_app/responsitory/category_repository.dart';
import 'package:notes_app/state/category_state.dart';
import 'package:notes_app/until/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Category'),
      ),
      body: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final nameController = TextEditingController();
  String emailController = '';
  final ageController = TextEditingController();
  final _categoryCubit = CategoryCubit(CategoryRepository());
  int? _statusCode;
  bool isChecked = true;
  bool _isLoading = false;

  Future<void> _refresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      emailController = pref.getString('email') ?? "";
      _isLoading = true;
      _categoryCubit.getAllCategory(emailController);
      isChecked = pref.getBool('remember') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    _statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? BlocProvider.value(
              value: _categoryCubit,
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is InitialCategoryState ||
                      state is LoadingCategoryState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SuccessLoadAllCategoryState) {
                    final categories = state.categoryData;
                    final data = categories.data;
                    _statusCode = categories.status;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final info = data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text('Category: ${info[0]}'),
                              subtitle: Text('Email: ${info[1]}'),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () => _showForm(info[0]),
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () =>
                                            _categoryCubit.deleteCategory(
                                                emailController, '${info[0]}'),
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FailureCategoryState) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return Text(state.toString());
                },
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  final TextEditingController _categoryController = TextEditingController();

  List<String> body = [];

  void _showForm(String? name) async {
    if (name != null) {
      _categoryController.text = name;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(hintText: 'Category'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (name == null) {
                  // List body{'kyle@r2s.com.vn', }
                  body.addAll({emailController, _categoryController.text});
                  await _categoryCubit.createCategory(body);
                  if (_statusCode == 1) {
                    _categoryCubit.getAllCategory(emailController);
                  } else if (_statusCode == -1 && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Name is null. Please re-enter name')));
                  }
                }

                if (name != null) {
                  body.addAll(
                      {emailController, name, _categoryController.text});
                  await _categoryCubit.editCategory(body);
                  if (_statusCode == 1) {
                    _categoryCubit.getAllCategory(emailController);
                  } else if (_statusCode == -1 && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Name is already exists')));
                  }
                }

                _categoryController.text = '';

                if (!mounted) return;

                body.clear();

                Navigator.of(context).pop();
              },
              child: Text(name == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      ),
    );
  }
}
