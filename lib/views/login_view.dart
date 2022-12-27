import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/services/auth/auth_exceptions.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/utilities/show_error_dialog.dart';

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
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
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
              child: const Text('Login')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Don't have an account? Register here."),
          )
        ],
      ),
    );
  }
}
