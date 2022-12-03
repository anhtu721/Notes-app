import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/category_cubit.dart';
import 'package:notes_app/cubit/note_cubit.dart';
import 'package:notes_app/cubit/priority_cubit.dart';
import 'package:notes_app/cubit/status_cubit.dart';
import 'package:notes_app/model/note_data.dart';
import 'package:notes_app/responsitory/category_repository.dart';
import 'package:notes_app/responsitory/note_repository.dart';
import 'package:notes_app/responsitory/priority_repository.dart';
import 'package:notes_app/responsitory/status_repository.dart';
import 'package:notes_app/state/category_state.dart';
import 'package:notes_app/state/note_state.dart';
import 'package:notes_app/state/priority_state.dart';
import 'package:notes_app/state/status_state.dart';
import 'package:notes_app/until/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Notes'),
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
  final _noteCubit = NoteCubit(NoteRepository());
  final _priorityCubit = PriorityCubit(PriorityRepository());
  final _categoryCubit = CategoryCubit(CategoryRepository());
  final _statusCubit = StatusCubit(StatusRepository());
  bool isUpdate = false;
  final TextEditingController _noteNameController = TextEditingController();
  late DateTime _date = DateTime(2022, 10, 26);
  late String? _selectedDate = '2022/10/26';
  String? dropdownPriority;
  String? dropdownCategory;
  String? dropdownStatus;
  int? statusCode = 0;
  int? statusError = 0;
  List<String> listNote = [];
  String oldName = '';
  // late NoteData notedata;
  String email = '';
  bool isChecked = true;
  final List<String> contents = ['Edit note', 'Delete'];

  Future<void> _refresh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      email = pref.getString('email') ?? "";
      _noteCubit.getAllNote(email);
      _priorityCubit.getAllPriority(email);
      _categoryCubit.getAllCategory(email);
      _statusCubit.getAllStatus(email);
      isChecked = pref.getBool('remember') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _noteCubit,
        child: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is InitialNoteState || state is LoadingNoteState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SuccessLoadAllNoteState) {
              final notes = state.listNote;
              statusCode = notes.status;

              final data = notes.data;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final info = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text('Name: ${info[0]}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Priority: ${info[2]}'),
                            Text('Category: ${info[1]}'),
                            Text('Status: ${info[3]}'),
                            Text('Date: ${info[4]}'),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return contents
                                .map((e) => PopupMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList();
                          },
                          onSelected: (value) async {
                            switch (value) {
                              case 'Edit note':
                                listNote.clear();
                                isUpdate = true;
                                _noteNameController.text = info[0];
                                dropdownCategory = info[1];
                                dropdownPriority = info[2];
                                dropdownStatus = info[3];
                                _selectedDate = info[4];
                                oldName = info[0];
                                _showDialog(context, info);
                                _noteCubit.getAllNote(email);

                                break;
                              case 'Delete':
                                await _noteCubit.deleteNotes(email, info[0]);
                                if (statusCode == 1) {
                                  _noteCubit.getAllNote(email);
                                }
                                break;
                            }
                          },
                        ),
                        // trailing: PopupMenuButton<int>(
                        //   itemBuilder: (context) => [
                        //     // PopupMenuItem 1
                        //     PopupMenuItem(
                        //       value: 1,
                        //       // row with 2 children
                        //       child: IconButton(
                        //           icon: const Icon(Icons.edit),

                        //           onPressed: () {
                        //             listNote.clear();
                        //             isUpdate = true;
                        //             _noteNameController.text = info[0];
                        //             dropdownCategory = info[1];
                        //             dropdownPriority = info[2];
                        //             dropdownStatus = info[3];
                        //             _selectedDate = info[4];
                        //             oldName = info[0];
                        //             _showDialog(context, info);
                        //             _noteCubit.getAllNote(email);
                        //           }),

                        //     ),
                        //     PopupMenuItem(
                        //       value: 2,
                        //       // row with two children
                        //       child: IconButton(
                        //           onPressed: () async {
                        //             await _noteCubit.deleteNotes(
                        //                 email, info[0]);
                        //             if (statusCode == 1) {
                        //               _noteCubit.getAllNote(email);
                        //             }
                        //             // else if(statusCode==-1 && mounted){
                        //             //   ScaffoldMessenger.of(context).showSnackBar(
                        //             //       const SnackBar(
                        //             //           content: Text('Note Used')
                        //             //       )
                        //             //   );
                        //             // }
                        //           },
                        //           icon: const Icon(Icons.delete)),
                        //     ),
                        //   ],
                        // ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is FailureNoteState) {
              return Center(child: Text(state.errorMessage));
            }
            return Text(state.toString());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // listNote.clear();
            isUpdate = false;
            _noteNameController.text = '';
            _showDialog(context, null);
            _noteCubit.getAllNote(email);
          },
          label: const Text('Add Note')),
    );
  }

  Future<void> _showDialog(BuildContext context, List<dynamic>? note) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(isUpdate ? 'Update Note' : 'Create new Note'),
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          // listNote.clear();
                          if (isUpdate == true) {
                            await _noteCubit.updateNotes(
                                oldName,
                                DataAddNote(
                                  name: _noteNameController.text,
                                  priority: dropdownPriority,
                                  category: dropdownCategory,
                                  status: dropdownStatus,
                                  date: _selectedDate,
                                  email: email,
                                ));
                            if (statusCode == 1) {
                              _noteCubit.getAllNote(email);
                            } else if (statusCode == -1 && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Name is null. Please re-enter name.')));
                            }
                          }

                          if (isUpdate == false) {
                            await _noteCubit.createNotes(DataAddNote(
                                name: _noteNameController.text,
                                priority: dropdownPriority,
                                category: dropdownCategory,
                                status: dropdownStatus,
                                date: _selectedDate,
                                email: email));
                            if (statusCode == 1) {
                              _noteCubit.getAllNote(email);
                            } else if (statusCode == -1 && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Name is already exists.')));
                            }
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
                body: BlocProvider.value(
                  value: _noteCubit,
                  child: BlocListener<NoteCubit, NoteState>(
                    listener: (_, state) {
                      if (state is SuccessSubmitNoteState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Note add successfully')));
                        setState(() {
                          _noteNameController.clear();
                        });
                      } else if (state is SuccessSubmitNoteState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Note update successfully')));
                      } else if (state is FailureNoteState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Successfully')));
                      }
                    },
                    child: Stack(
                      children: [_buildFormWidget(), _buildLoadingWidget()],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  void dispose() {
    super.dispose();
    _noteNameController.dispose();
  }

  Widget _buildFormWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'Enter name',
                // labelText: 'Note',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people)),
            controller: _noteNameController,
          ),
          //Priority
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: BlocProvider.value(
              value: _priorityCubit,
              child: BlocBuilder<PriorityCubit, PriorityState>(
                builder: (context, state) {
                  if (state is InitialPriorityState ||
                      state is LoadingPriorityState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SuccessLoadAllPriorityState) {
                    final priorities = state.priorityData;
                    final data = priorities.data;
                    Set<String> list = {for (var v in data) v[0].toString()};
                    return DropdownButtonFormField<String>(
                      hint: const Text("Select Priority"),
                      value: dropdownPriority,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Priority',
                          prefixIcon: Icon(Icons.low_priority_sharp)),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownPriority = value;
                        });
                      },
                      items: list.map((priorityItem) {
                        return DropdownMenuItem<String>(
                          value: priorityItem,
                          child: Text(priorityItem),
                        );
                      }).toList(),
                    );
                  } else if (state is FailurePriorityState) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return Text(state.toString());
                },
              ),
            ),
          ),
          //Category
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: BlocProvider.value(
              value: _categoryCubit,
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is InitialCategoryState ||
                      state is LoadingCategoryState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SuccessLoadAllCategoryState) {
                    final categories = state.categoryData;
                    final data = categories.data;
                    Set<String> list = {for (var v in data) v[0].toString()};
                    return DropdownButtonFormField<String>(
                      hint: const Text("Select Category"),
                      value: dropdownCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.tag)),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownCategory = value;
                        });
                      },
                      items: list.map((categoryItem) {
                        return DropdownMenuItem<String>(
                          value: categoryItem,
                          child: Text(categoryItem),
                        );
                      }).toList(),
                    );
                  } else if (state is FailureCategoryState) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return Text(state.toString());
                },
              ),
            ),
          ),
          //Status
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: BlocProvider.value(
              value: _statusCubit,
              child: BlocBuilder<StatusCubit, StatusState>(
                builder: (context, state) {
                  if (state is InitialStatusState ||
                      state is LoadingStatusState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SuccessLoadAllStatusState) {
                    final status = state.statusData;
                    final data = status.data;
                    Set<String> list = {for (var v in data) v[0].toString()};
                    return DropdownButtonFormField<String>(
                      hint: const Text("Select Status"),
                      value: dropdownStatus,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.dehaze)),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownStatus = value;
                        });
                      },
                      items: list.map((statusItem) {
                        return DropdownMenuItem<String>(
                          value: statusItem,
                          child: Text(statusItem),
                        );
                      }).toList(),
                    );
                  } else if (state is FailureStatusState) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return Text(state.toString());
                },
              ),
            ),
          ),
          //Date
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  // border: Border.all(color: Colors.orange,width: 1),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Row(
                      children: const [
                        Icon(Icons.date_range_outlined, color: Colors.white),
                        Text('Select date'),
                      ],
                    ),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2200),
                      );
                      if (newDate == null) return;

                      setState(() => _date = newDate);
                      _selectedDate =
                          '${_date.year}/${_date.month}/${_date.day}';
                    },
                  ),
                  Text(
                    '$_selectedDate',
                    style: const TextStyle(fontSize: 25),
                  ),
                  // const SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return BlocBuilder<NoteCubit, NoteState>(builder: (_, state) {
      if (state is LoadingNoteState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Container();
      }
    });
  }
}
