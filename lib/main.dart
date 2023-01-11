import 'package:flutter/material.dart';
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/views/diary/diary_view.dart';
import 'package:mynotes1/views/goals/create_update_goal_view.dart';
import 'package:mynotes1/views/goals/goals_view.dart';
import 'package:mynotes1/views/login_view.dart';
import 'package:mynotes1/views/notes/create_update_note_view.dart';
import 'package:mynotes1/views/notes/notes_view.dart';
import 'package:mynotes1/views/questions/create_update_question_view.dart';
import 'package:mynotes1/views/questions/questions_view.dart';
import 'package:mynotes1/views/rating/rating_view.dart';
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
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      goalsRoute: (context) => const GoalsView(),
      createOrUpdateGoalRoute: (context) => const CreateUpdateGoalView(),
      questionsRoute: (context) => const QuestionsView(),
      createOrUpdateQuestionRoute: (context) =>
          const CreateUpdateQuestionView(),
      ratingRoute: (context) => const RatingView(),
      diaryRoute: (context) => const DiaryView(),
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
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
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
