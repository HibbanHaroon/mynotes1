import 'package:flutter/material.dart';
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/enums/menu_action.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  //IDK why we used exclamation marks with currentUser and email
  //a getter for email to use in notes view
  String get userEmail => AuthService.firebase().currentUser!.email!;

  //when reaching the notes view, we are making sure that the database is connected.
  //similarly when exiting, we need to make sure that the connection is disposed.
  @override
  void initState() {
    //singleton is basiclally one copy through out the project.
    _notesService = NotesService();
    //We don't need to open the database here as all the operations in the notesService are
    //opening the database by using the method _ensureDbIsOpen()
    //_notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        //A menu can be opened by the three dots
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Text("Waiting for all the notes");
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
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
