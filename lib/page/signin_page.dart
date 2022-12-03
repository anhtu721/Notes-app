import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/signin_cubit.dart';
import 'package:notes_app/model/user/signin_model.dart';
import 'package:notes_app/page/dashboard_page.dart';
import 'package:notes_app/page/signup_page.dart';
import 'package:notes_app/responsitory/signin_responsitory.dart';
import 'package:notes_app/state/signin_state.dart';
import 'package:notes_app/until/constances.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Management Systems'),
      ),
      body: const SignInForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const SignUpPage())),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool remember = false;
  final _formKeySignIn = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final getEmail = TextEditingController();
  final getPass = TextEditingController();

  late String firstname = '';
  late String lastname = '';
  final signInCutbit = SignInCubit(SignInResponsitory());
  bool isChecked = false;

  Future<void> initValue() async {
    // init SharedPrefernce
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _emailTextController.text = pref.getString('email') ?? '';
      _passwordTextController.text = pref.getString('pass') ?? '';

      isChecked = pref.getBool('remember') ?? false;

      if (isChecked) {
        _emailTextController.text = pref.getString('email')!;
        _passwordTextController.text = pref.getString('pass')!;
      } else {
        //add code
        _emailTextController.text = '';
        _passwordTextController.text = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initValue();
  }

  // set remeber
  void setRemember(bool flag) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (flag) {
      pref.setString('email', _emailTextController.text);
      pref.setString('pass', _passwordTextController.text);
    } else {
      pref.setString('email', _emailTextController.text);
      pref.setString('pass', _passwordTextController.text);
    }
    pref.setBool('remember', flag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: signInCutbit,
        child: BlocListener<SignInCubit, SignInState>(
          listener: (_, state) async {
            if (state is InitialSignInState) {
              const Center(child: CircularProgressIndicator());
            } else if (state is SuccessfulSignInState) {
              final stateSignIn = state.signInResponse;
              final statusSignIn = stateSignIn.status;
              final firstName = stateSignIn.info?.firstName;
              final lastName = stateSignIn.info?.lastName;
              final errorSignIn = stateSignIn.error;
              // status = 1 -> successful
              if (statusSignIn == Constance.statusCode1) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successfully.')));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashBoardPage()),
                    (route) => false);

                SharedPreferences pref = await SharedPreferences.getInstance();
                // save data when sign in successful
                pref.setString('FirstName', firstName!);
                pref.setString('LastName', lastName!);
              }
              // status = -1 & error = 2 -> Password is wrong
              else if (statusSignIn == Constance.statusCodeSub1 &&
                  errorSignIn == Constance.statusError2) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password is wrong.')));
              }
              // status = -1 & error = 1 -> Email has not existed
              else if (statusSignIn == Constance.statusCodeSub1 &&
                  errorSignIn == Constance.statusError1) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email has not existed.')));
              }
            } else if (state is FailureSignInState) {
              Center(child: Text(state.message));
            }
            Text(state.toString());
          },
          //interface declaration
          child: _buildSignInForm(),
        ),
      ),
    );
  }

  // Form sign in
  Widget _buildSignInForm() {
    return Form(
      key: _formKeySignIn,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Note Management System'),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _passwordTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const Text('Remember me'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKeySignIn.currentState!.validate()) {
                        var dataSignIn = SignInRequest(
                          email: _emailTextController.text,
                          pass: _passwordTextController.text,
                        );
                        signInCutbit.getSignIn(dataSignIn);
                        setRemember(isChecked);
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Exit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
