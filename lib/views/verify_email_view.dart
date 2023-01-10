import 'package:flutter/material.dart';
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const Text(
              "We've already sent you an email verification. Please open it to verify your account.",
            ),
            const Text(""),
            const Text(
                "If you haven't received your email yet, press the button below"),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text(
                  'Resend Email Verification',
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
              child: ElevatedButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
