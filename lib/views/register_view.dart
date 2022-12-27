import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/utilities/show_error_dialog.dart';
import 'package:mynotes1/views/verify_email_view.dart';

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
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                //sending the email for the user beforehand so the user only has to verify it
                await user?.sendEmailVerification();
                devtools.log(userCredential.toString());
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  //These catches should display a toast message.
                  devtools.log('Email already in use');
                  await showErrorDialog(
                    context,
                    'Email already in use',
                  );
                } else if (e.code == 'weak-password') {
                  devtools.log('Weak Password');
                  await showErrorDialog(
                    context,
                    'Weak Password',
                  );
                } else if (e.code == 'invalid-email') {
                  devtools.log('Invalid email entered');
                  await showErrorDialog(
                    context,
                    'Invalid email entered',
                  );
                } else if (e.code == 'email-already-in-use') {
                  devtools.log('Email is already in use.');
                  await showErrorDialog(
                    context,
                    'Email is already in use.',
                  );
                } else {
                  devtools.log('Error ${e.code}');
                  await showErrorDialog(context, 'Error: ${e.code},');
                }
              } catch (e) {
                devtools.log(e.toString());
                await showErrorDialog(
                  context,
                  e.toString(),
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
