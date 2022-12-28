import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  //const constructors cannot have a body and this is used for final
  //immutable means that any variables of this class or it's child classes cannot change i.e., of var type wtihout final
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);

  //What the above line does that it takes the email verified from the the Firebase user
  //and saves it in the new instance that we created of our class
  //factory is used because it's its reponsibility to get the value of email verified from the Firebase User
  //and save it in the instance.
}
