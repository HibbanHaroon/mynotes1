import 'package:flutter/material.dart';
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/enums/menu_action.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/services/auth/auth_user.dart';
import 'package:mynotes1/services/cloud/goals/cloud_goal.dart';
import 'package:mynotes1/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes1/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes1/views/goals/goals_list_view.dart';

class GoalsView extends StatefulWidget {
  const GoalsView({Key? key}) : super(key: key);

  @override
  State<GoalsView> createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {
  late final FirebaseCloudStorage _goalsService;
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
    _goalsService = FirebaseCloudStorage();
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
        title: const Text('My Goals'),
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
        stream: _goalsService.allGoals(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allGoals = snapshot.data as Iterable<CloudGoal>;
                return GoalsListView(
                  goals: allGoals,
                  onDeleteGoal: (goal) async {
                    await _goalsService.deleteGoal(documentId: goal.documentId);
                  },
                  onTap: (goal) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateGoalRoute,
                      arguments: goal,
                    );
                  },
                );
              } else {
                //return const CircularProgressIndicator();
                return const Text('No goals yet.');
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateGoalRoute);
        },
        tooltip: 'Add Goal',
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
            ),
            /*
            const ListTile(
              leading: Icon(Icons.rate_review),
              title: Text(
                'Rate Your Day',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
            ),*/
            ListTile(
              leading: const Icon(Icons.question_mark),
              title: const Text(
                'Know Yourself',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  questionsRoute,
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: const Text(
                'Goals',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  goalsRoute,
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sticky_note_2),
              title: const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}