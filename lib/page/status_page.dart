import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/status_cubit.dart';
import 'package:notes_app/state/status_state.dart';
import 'package:notes_app/responsitory/status_repository.dart';
import 'package:notes_app/until/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Status'),
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
  final _statusCubit = StatusCubit(StatusRepository());
  int? _statusCode;
  bool isChecked = true;

  Future<void> _refresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      emailController = pref.getString('email') ?? "";
      _statusCubit.getAllStatus(emailController);
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
      body: BlocProvider.value(
        value: _statusCubit,
        child: BlocBuilder<StatusCubit, StatusState>(
          builder: (context, state) {
            if (state is InitialStatusState || state is LoadingStatusState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SuccessLoadAllStatusState) {
              final statuses = state.statusData;
              final data = statuses.data;
              _statusCode = statuses.status;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final info = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text('Status: ${info[0]}'),
                        subtitle: Text('Email: ${info[1]}'),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => _showForm(info[0]),
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () => _statusCubit.deleteStatus(
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
            } else if (state is FailureStatusState) {
              return Center(child: Text(state.errorMessage));
            }
            return Text(state.toString());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  final TextEditingController _statusController = TextEditingController();

  List<String> body = [];

  void _showForm(String? name) async {
    if (name != null) {
      _statusController.text = name;
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
              controller: _statusController,
              decoration: const InputDecoration(hintText: 'Status'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (name == null) {
                  body.addAll({emailController, _statusController.text});
                  await _statusCubit.createStatus(body);
                  if (_statusCode == 1) {
                    _statusCubit.getAllStatus(emailController);
                  } else if (_statusCode == -1 && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Name is null. Please re-enter name')));
                  }
                }
                if (name != null) {
                  body.addAll({emailController, name, _statusController.text});
                  await _statusCubit.editStatus(body);
                  if (_statusCode == 1) {
                    _statusCubit.getAllStatus(emailController);
                  } else if (_statusCode == -1 && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Name is already exists')));
                  }
                }
                _statusController.text = '';
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
