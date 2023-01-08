import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/services/auth/auth_exceptions.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Enter your email here'),
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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                //sending the email for the user beforehand so the user only has to verify it
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on EmailAlreadyInUseAuthException {
                devtools.log('Email already in use');
                await showErrorDialog(
                  context,
                  'Email already in use',
                );
              } on WeakPasswordAuthException {
                devtools.log('Weak Password');
                await showErrorDialog(
                  context,
                  'Weak Password',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Invalid email entered',
                );
              } on GenericAuthException {
                devtools.log('Failed to Register.');
                await showErrorDialog(
                  context,
                  'Failed to Register.',
                );
              }
            },
            child: const Text('Register')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already have an account? Login here.')),
      ]),
    );
  }
}
