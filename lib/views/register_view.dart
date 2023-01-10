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
                    child: ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: const Text(
                        'Register',
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
                          loginRoute,
                          (route) => false,
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: const Text('Already have an account? Login here.'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
