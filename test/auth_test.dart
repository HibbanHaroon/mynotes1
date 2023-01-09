import 'package:mynotes1/services/auth/auth_exceptions.dart';
import 'package:mynotes1/services/auth/auth_provider.dart';
import 'package:mynotes1/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    //The test below means that it is expected that logout will throw not initialized exception
    test('Cannot logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });
    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    //A useful test case to test API Calls.
    //after initialize it expects the isInitialize to be true,
    //if this doesn't happen in 2 seconds then we know the test failed
    //due to the timeout that started when the test case started.
    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create User should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'someone@gmail.com',
        password: 'someone',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'notsomeone@gmail.com',
        password: 'someone123',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'someone',
        password: 'someone',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'someone@gmail.com') throw UserNotFoundAuthException();
    if (password == 'someone123') throw WrongPasswordAuthException();
    const user = AuthUser(
      id: "my_id",
      isEmailVerified: false,
      email: 'someone@gmail.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: "my_id",
      isEmailVerified: true,
      email: 'someone@gmail.com',
    );
    _user = newUser;
  }
}
