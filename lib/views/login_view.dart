import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/services/auth/auth_exceptions.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      controller: _email,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          filled: true, //<-- SEE HERE
                          fillColor: Color(0xffddf0dd),
                          hintText: 'Enter your email here',
                          contentPadding: const EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Color(0xffddf0dd),
                              ),
                              borderRadius: BorderRadius.circular(30))),
                      onChanged: (value) {
                        // do something
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          filled: true, //<-- SEE HERE
                          fillColor: Color(0xffddf0dd),
                          hintText: 'Enter your password here',
                          contentPadding: const EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Color(0xffddf0dd),
                              ),
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase().logIn(
                            email: email,
                            password: password,
                          );
                          final user = AuthService.firebase().currentUser;
                          if (user?.isEmailVerified ?? false) {
                            //user's email is verified.
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoute,
                              (route) => false,
                            );
                          } else {
                            //user's email is not verified.
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute,
                              (route) => false,
                            );
                          }
                          /*Navigator.of(context).pushNamedAndRemoveUntil('', (route) => false)*/
                        } on UserNotFoundAuthException {
                          devtools.log('User not found.');
                          await showErrorDialog(
                            context,
                            'User Not Found',
                          );
                        } on WrongPasswordAuthException {
                          devtools.log('Wrong Password');
                          await showErrorDialog(
                            context,
                            'Incorrect Password',
                          );
                        } on GenericAuthException {
                          devtools.log('Authentication error.');
                          await showErrorDialog(
                            context,
                            'Authentication Error.',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute,
                          (route) => false,
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: const Text(
                        "Don't have an account? Register here.",
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
