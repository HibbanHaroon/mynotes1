import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/firebase_options.dart';
import 'package:mynotes1/views/login_view.dart';
import 'package:mynotes1/views/register_view.dart';
import 'package:mynotes1/views/verify_email_view.dart';
import 'dart:developer' as devtools
    show
        log; //show is used to choose from so many functions present in the import what we actually need
//as is used to give that function a unique name

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

//Stateful vs Stateless
//Hot reload keep your data such as when we make changes
//and then we hot reload it... the number is not changed.
//Stateful Widget maintains the data and keep track of it. It can change the data.
//Stateless Widget cannot contain any mutabel data i.e., it cannot change the data.
//stl is a shortcut for stateless widget
//What is a widget? What is a scaffold?
//Difference between Scaffold and Container
//PopupMenuButton vs PopupMenuItem
//difference between optional future and future optional
//Center tries to center the child vertically and horizontally
//Column Widget is used to stack widgets
//late is basically it doesn't have any value now but it will have a value before using that variable.
//Stateful Widgets have init and dispose method
//Init is used to initialize everything when that class of widget is called/used.
//Dispose is used when we want to to dispose the widget... no longer need it.
//print(e.runtimeType); //shows the type of error
//Chapter 14: We do not push a widget inside a Future Builder
//Chapter 16: Named Router vs Anonymous Router
//use overlay so that the dialog stays
//

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                //user is present and account is verified
                devtools.log('You are a verified user.');
                return const NotesView();
              } else {
                //user is present but email is not verified.
                devtools.log('You need to verify your email first.');
                return const VerifyEmailView();
              }
            } else {
              //user is not present
              return const LoginView();
            }
          default:
            //Instead of writing Loading
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout, setting }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        //A menu can be opened by the three dots
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
                case MenuAction.setting:
                  // TODO: Handle this case.
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Logout')),
                PopupMenuItem<MenuAction>(
                    value: MenuAction.setting, child: Text('Setting'))
              ];
            },
          )
        ],
      ),
      body: const Text('Bellow!'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sign out')),
        ],
      );
    },
  ).then((value) => value ?? false);
  //then means if value is null which can be due to user pressing back button
  //so return false
  //Future is used because the response depends on the user and not us... It is not instant or pre-determined.
}
