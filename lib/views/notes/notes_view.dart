import 'package:flutter/material.dart';
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/enums/menu_action.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/services/auth/auth_user.dart';
import 'package:mynotes1/services/cloud/cloud_note.dart';
import 'package:mynotes1/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes1/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes1/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  //IDK why we used exclamation marks with currentUser and email
  //a getter for email to use in notes view
  AuthUser get user => AuthService.firebase().currentUser!;
  String get userId => user.id;
  String get userEmail => user.email;

  //when reaching the notes view, we are making sure that the database is connected.
  //similarly when exiting, we need to make sure that the connection is disposed.
  @override
  void initState() {
    //singleton is basiclally one copy through out the project.
    _notesService = FirebaseCloudStorage();
    //We don't need to open the database here as all the operations in the notesService are
    //opening the database by using the method _ensureDbIsOpen()
    //_notesService.open();
    super.initState();
  }
/*
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }
*/

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
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                //return const CircularProgressIndicator();
                return const Text('No notes yet.');
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Center(
              child: UserAccountsDrawerHeader(
                accountEmail: Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    userEmail[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                accountName: null,
              ),
            ), /*
            const ListTile(
              leading: Icon(Icons.rate_review),
              title: Text(
                'Rate Your Day',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.question_mark),
              title: Text(
                'Know Yourself',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.sports_soccer),
              title: Text(
                'Goals',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.sticky_note_2),
              title: Text(
                'Notes',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
