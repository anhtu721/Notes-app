import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/cubit_change.dart';
import 'package:notes_app/page/dashboard_page.dart';
import 'package:notes_app/responsitory/repository_change.dart';
import 'package:notes_app/state/state_change.dart';
import 'package:notes_app/until/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

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
  final _formChangePassword = GlobalKey<FormState>();
  final _emailCurrent = TextEditingController();
  final _passCurrent = TextEditingController();
  final _passNew = TextEditingController();
  final changePasswordCubit = ChangePasswordCubit(ChangePasswordRepository());

  Future<void> _initValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var emailCurrent = pref.getString('email');
    _emailCurrent.text =
        emailCurrent!; //show current email on profile edit form
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
          title: const Text('ChangePassword'),
        ),
        body: BlocProvider.value(
          value: changePasswordCubit,
          child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listener: (_, state) {
              if (state is InitialChangePasswordState) {
                const Center(child: CircularProgressIndicator());
              } else if (state is SuccessChangePasswordState) {
                final changepassword = state.changePasswordData;
                final sta = changepassword.status;
                if (sta == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Change password successfully')));
                  setState(() {
                    _emailCurrent.clear();
                    _passCurrent.clear();
                    _passNew.clear();
                  });
                } else if (sta == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fail old password')));
                } else {
                  //can't down this case
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ChangePassword fail')));
                }
              } else if (state is FailureChangePasswordState) {
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
    _passCurrent.dispose();
    _passNew.dispose();
  }

  Widget _buildWidgetForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formChangePassword,
            child: Column(children: [
              const Text(
                'Change Password',
                style: TextStyle(fontSize: 28, color: Colors.blueAccent),
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
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter current password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Enter you current password'),
                  controller: _passCurrent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Enter your new password'),
                  controller: _passNew,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formChangePassword.currentState!.validate()) {
                          final emailCr = _emailCurrent.text;
                          final passCr = _passCurrent.text;
                          final passNe = _passNew.text;
                          changePasswordCubit.updatePassword(
                              emailCr, passCr, passNe);
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          //save the Pass to shared when pressing Change
                          pref.setString('pass', passNe);
                        }
                      },
                      child: const Text('Change'),
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
