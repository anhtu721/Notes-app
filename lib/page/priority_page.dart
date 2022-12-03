import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/priority_cubit.dart';
import 'package:notes_app/responsitory/priority_repository.dart';
import 'package:notes_app/state/priority_state.dart';
import 'package:notes_app/until/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriorityPage extends StatelessWidget {
  const PriorityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Priority'),
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
  final _priorityCubit = PriorityCubit(PriorityRepository());
  int? _statusCode;
  bool isChecked = true;
  bool _isLoading = false;

  Future<void> _refresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      emailController = pref.getString('email') ?? "";
      _isLoading = true;
      _priorityCubit.getAllPriority(emailController);
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
              value: _priorityCubit,
              child: BlocBuilder<PriorityCubit, PriorityState>(
                builder: (context, state) {
                  if (state is InitialPriorityState ||
                      state is LoadingPriorityState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SuccessLoadAllPriorityState) {
                    final prioritys = state.priorityData;
                    final data = prioritys.data;
                    _statusCode = prioritys.status;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final info = data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text('Priority: ${info[0]}'),
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
                                            _priorityCubit.deletePriority(
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
                  } else if (state is FailurePriorityState) {
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

  final TextEditingController _priorityController = TextEditingController();

  List<String> body = [];

  void _showForm(String? name) async {
    if (name != null) {
      _priorityController.text = name;
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
              controller: _priorityController,
              decoration: const InputDecoration(hintText: 'Priority'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (name == null) {
                  body.addAll({emailController, _priorityController.text});
                  await _priorityCubit.createPriority(body);
                  if (_statusCode == 1) {
                    _priorityCubit.getAllPriority(emailController);
                  } else if (_statusCode == -1 && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Name is null. Please re-enter name')));
                  }
                } else {
                  body.addAll(
                      {emailController, name, _priorityController.text});
                  await _priorityCubit.editPriority(body);
                  if (_statusCode == 1) {
                    _priorityCubit.getAllPriority(emailController);
                  } else if (_statusCode == -1 && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Name is already exists')));
                  }
                }

                _priorityController.text = '';

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
