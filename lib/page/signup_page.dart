import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/signup_cubit.dart';
import 'package:notes_app/model/user/signup_model.dart';
import 'package:notes_app/page/signin_page.dart';
import 'package:notes_app/responsitory/signup_responsitory.dart';
import 'package:notes_app/state/signup_state.dart';
import 'package:notes_app/until/constances.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Management System'),
      ),
      body: const SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();

  final _formKeySignUp = GlobalKey<FormState>();
  final signUpCutbit = SignUpCubit(SignUpResponsitory());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        body: BlocProvider.value(
          value: signUpCutbit,
          child: BlocListener<SignUpCubit, SignUpState>(
            listener: (_, state) {
              if (state is InitialSignUpState) {
                const Center(child: CircularProgressIndicator());
              } else if (state is SuccessfulSignUpState) {
                final stateSignUp = state.signUpResponse;
                final statusSignUp = stateSignUp.status;
                final errorSignUp = stateSignUp.error;
                // status = 1 -> sign up successful
                if (statusSignUp == Constance.statusCode1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign up successfully')));
                  setState(() {
                    _emailTextController.clear();
                    _passwordTextController.clear();
                    _firstNameTextController.clear();
                    _lastNameTextController.clear();
                    _confirmPasswordTextController.clear();
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignInPage()));
                }
                // status = -1 & error = 2 -> email used, cant sign up
                else if (statusSignUp == Constance.statusCodeSub1 ||
                    errorSignUp == Constance.statusError2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email used')));
                }
              } else if (state is FailureSignUpState) {
                Center(child: Text(state.message));
              }
              Text(state.toString());
            },
            // interface declaration
            child: _buildSignUpForm(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
  }

  Widget _buildSignUpForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKeySignUp,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text('Sign Up Form'),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _emailTextController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    }),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _firstNameTextController,
                    decoration: const InputDecoration(
                      hintText: 'First name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name.';
                      }
                      return null;
                    }),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _lastNameTextController,
                    decoration: const InputDecoration(
                      hintText: 'Last name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name.';
                      }
                      return null;
                    }),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                TextFormField(
                    controller: _confirmPasswordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter confirm password';
                      } else if (value != _passwordTextController.text) {
                        return 'Confirm password is wrong';
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKeySignUp.currentState!.validate()) {
                          final signUpdata = SignUpRequest(
                            email: _emailTextController.text,
                            pass: _passwordTextController.text,
                            firstname: _firstNameTextController.text,
                            lastname: _lastNameTextController.text,
                          );
                          signUpCutbit.getSignUp(signUpdata);
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SignInPage())),
                      child: const Text('Sign In'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
