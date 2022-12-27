//This class will provide an interface to every provider that our application can work with
import 'package:mynotes1/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currectUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
