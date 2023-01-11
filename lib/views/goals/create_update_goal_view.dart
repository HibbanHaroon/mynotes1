import 'package:flutter/material.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/services/cloud/goals/cloud_goal.dart';
import 'package:mynotes1/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes1/utilities/generics/get_arguments.dart';
import 'package:mynotes1/utilities/dialogs/cannot_share_empty_goal_dialog.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateGoalView extends StatefulWidget {
  const CreateUpdateGoalView({super.key});

  @override
  State<CreateUpdateGoalView> createState() => _CreateUpdateGoalViewState();
}

class _CreateUpdateGoalViewState extends State<CreateUpdateGoalView> {
  //_note to keep track of the note... so a new note isn't created everytime build method is called
  CloudGoal? _goal;
  late final FirebaseCloudStorage _goalsService;
  //to keep track of the input the user is entering.
  late final TextEditingController _textController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    _goalsService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final goal = _goal;
    if (goal == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;
    await _goalsService.updateGoal(
      documentId: goal.documentId,
      title: title,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _titleController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    _titleController.addListener(_textControllerListener);
  }

  Future<CloudGoal> createOrGetExistingGoal(BuildContext context) async {
    final widgetGoal = context.getArgument<CloudGoal>();
    //user can come to this method either by clicking on the note or simply clicking on the plus icon
    //in the latter case there will be widgetNote will be null.

    //If the note exists i.e., user clicked on a note to edit it then we do the following
    if (widgetGoal != null) {
      _goal = widgetGoal;
      _textController.text = widgetGoal.text;
      _titleController.text = widgetGoal.title;
      return widgetGoal;
    }

    final existingGoal = _goal;
    if (existingGoal != null) {
      return existingGoal;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newGoal = await _goalsService.createNewGoal(ownerUserId: userId);
    _goal = newGoal;
    return newGoal;
  }

  void _deleteGoalIfTextIsEmpty() {
    final goal = _goal;
    final text = _textController.text;
    if (text.isEmpty && goal != null) {
      _goalsService.deleteGoal(documentId: goal.documentId);
    }
  }

  void _saveGoalIfTextNotEmpty() async {
    final goal = _goal;
    final text = _textController.text;
    final title = _titleController.text;
    if (text.isNotEmpty && goal != null) {
      await _goalsService.updateGoal(
        documentId: goal.documentId,
        title: title,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteGoalIfTextIsEmpty();
    _saveGoalIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Goal'),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_goal == null || text.isEmpty) {
                await showCannotShareEmptyGoalDialog(context);
              } else {
                //share the note with the title as well
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: Container(
        color: const Color(0xffddf0dd),
        child: Column(
          children: [
            FutureBuilder(
              future: createOrGetExistingGoal(context),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    _setupTextControllerListener();
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _titleController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter your title',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: _textController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: 'Start typing your goal...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    );
                  default:
                    return const CircularProgressIndicator();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
