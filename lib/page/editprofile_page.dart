import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/cubit_edit.dart';
import 'package:notes_app/page/dashboard_page.dart';
import 'package:notes_app/responsitory/repository_edit.dart';
import 'package:notes_app/state/state_edit.dart';
import 'package:notes_app/until/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final _formEditProfile = GlobalKey<FormState>();
  final _emailCurrent = TextEditingController();
  final _emailNew = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final editProfileCubit = EditProfileCubit(EditProfileRepository());

  Future<void> _initValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emailCurrent = pref.getString('email');
    var firstName = pref.getString('FirstName');
    var lastName = pref.getString('LastName');
    _emailCurrent.text =
        emailCurrent!; //show current email on profile edit form
    _firstName.text = firstName!; //show current firstName on profile edit form
    _lastName.text = lastName!; //show current lastName on profile edit form
  }

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('EditProfile'),
        ),
        body: BlocProvider.value(
          value: editProfileCubit,
          child: BlocListener<EditProfileCubit, EditProfileState>(
            listener: (_, state) {
              if (state is InitialEditProfileState) {
                const Center(child: CircularProgressIndicator());
              } else if (state is SuccessEditProfileState) {
                final editprofile = state.editProfileData;
                final sta = editprofile.status;
                if (sta == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Profile Edit successfully')));
                  setState(() {
                    _emailCurrent.clear();
                    _emailNew.clear();
                    _firstName.clear();
                    _lastName.clear();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile Edit fail')));
                }
              } else if (state is FailureEditProfileState) {
                Center(child: Text(state.errorMessage));
              }
              Text(state.toString());
            },
            child: _buildWidgetForm(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailCurrent.dispose();
    _emailNew.dispose();
    _firstName.dispose();
    _lastName.dispose();
  }

  Widget _buildWidgetForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
            key: _formEditProfile,
            child: Column(children: [
              const Text(
                'Edit profile',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.blueAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email current';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Enter you email current'),
                  controller: _emailCurrent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new email';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter you new email'),
                  controller: _emailNew,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter your first name'),
                  controller: _firstName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Enter your last name'),
                  controller: _lastName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formEditProfile.currentState!.validate()) {
                          final emailCr = _emailCurrent.text;
                          final emailNe = _emailNew.text;
                          final firstNa = _firstName.text;
                          final lastNa = _lastName.text;
                          editProfileCubit.updateProfile(
                              emailCr, emailNe, firstNa, lastNa);
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          //save the information to shared when pressing Edit
                          pref.setString('email', emailNe);
                          pref.setString('FirstName', firstNa);
                          pref.setString('LastName', lastNa);
                        }
                      },
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DashBoardPage()));
                      },
                      child: const Text('Home'),
                    )
                  ],
                ),
              )
            ])),
      ),
    );
  }
}
