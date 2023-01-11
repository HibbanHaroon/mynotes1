import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mynotes1/constants/routes.dart';
import 'package:mynotes1/enums/menu_action.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/services/auth/auth_user.dart';
import 'package:mynotes1/services/cloud/questions/cloud_question.dart';
import 'package:mynotes1/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes1/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes1/views/questions/questions_list_view.dart';

class RatingView extends StatefulWidget {
  const RatingView({Key? key}) : super(key: key);

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  /*late final FirebaseCloudStorage _questionsService;
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
    _questionsService = FirebaseCloudStorage();
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
*/
  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEEE', 'en_US').format(DateTime.now());
    String date = DateFormat('MMMMd', 'en_US').format(DateTime.now());
    String year = DateFormat('y', 'en_US').format(DateTime.now());
    String time = DateFormat('jms', 'en_US').format(DateTime.now());
    String location = 'Islamabad';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Day'),
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
      body: Container(
          color: const Color(0xffddf0dd),
          width: 400,
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          width: 270,
                          decoration: BoxDecoration(
                              color:
                                  Colors.white, // Your desired background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2),
                              ]),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        time,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        location,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        day,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        date,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        year,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //Title
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Colors.white, // Your desired background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Title',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 240,
                                    height: 50,
                                    child: TextField(
                                      //controller: _title,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          filled: true, //<-- SEE HERE
                                          fillColor: Color(0xffddf0dd),
                                          hintText:
                                              'Give your day a movie title',
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 3,
                                                color: Color(0xffddf0dd),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //Ratings
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Colors.white, // Your desired background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Rating',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    unratedColor: const Color(0xffddf0dd),
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.green,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //Title
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Colors.white, // Your desired background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Summary',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 240,
                                    height: 150,
                                    child: TextField(
                                      //controller: _title,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                          filled: true, //<-- SEE HERE
                                          fillColor: Color(0xffddf0dd),
                                          hintText: 'Summarize Your Day...',
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 3,
                                                color: Color(0xffddf0dd),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //Title
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Colors.white, // Your desired background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 240,
                                    height: 200,
                                    child: TextField(
                                      //controller: _title,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 9,
                                      decoration: InputDecoration(
                                          filled: true, //<-- SEE HERE
                                          fillColor: Color(0xffddf0dd),
                                          hintText:
                                              'Describe your day in great detail...',
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 3,
                                                color: Color(0xffddf0dd),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //Title
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Colors.white, // Your desired background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 258,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'What were the best things about your day today?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 240,
                                    height: 150,
                                    child: TextField(
                                      //controller: _title,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                          filled: true, //<-- SEE HERE
                                          fillColor: Color(0xffddf0dd),
                                          hintText: 'Best things were...',
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 3,
                                                color: Color(0xffddf0dd),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //Title
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Colors.white, // Your desired background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 258,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'What did you get to learn from your day today',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 240,
                                    height: 150,
                                    child: TextField(
                                      //controller: _title,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                          filled: true, //<-- SEE HERE
                                          fillColor: Color(0xffddf0dd),
                                          hintText: 'I learnt ...',
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 3,
                                                color: Color(0xffddf0dd),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
      drawer: Drawer(
        child: ListView(
          children: [
            const Center(
              child: UserAccountsDrawerHeader(
                accountEmail: Text(
                  'userEmail',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    'U',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                accountName: null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text(
                'Rate Your Day',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  ratingRoute,
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_stories),
              title: const Text(
                'Diary',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  diaryRoute,
                  (route) => false,
                );
              },
            ),
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
