import 'package:flutter/material.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/services/cloud/questions/cloud_question.dart';
import 'package:mynotes1/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes1/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes1/utilities/generics/get_arguments.dart';
import 'package:mynotes1/utilities/dialogs/cannot_share_empty_question_dialog.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateQuestionView extends StatefulWidget {
  const CreateUpdateQuestionView({super.key});

  @override
  State<CreateUpdateQuestionView> createState() =>
      _CreateUpdateQuestionViewState();
}

class _CreateUpdateQuestionViewState extends State<CreateUpdateQuestionView> {
  //_note to keep track of the note... so a new note isn't created everytime build method is called
  CloudQuestion? _question;
  late final FirebaseCloudStorage _questionsService;
  //to keep track of the input the user is entering.
  late final TextEditingController _textController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    _questionsService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final question = _question;
    if (question == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;
    await _questionsService.updateQuestion(
      documentId: question.documentId,
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

  Future<CloudQuestion> createOrGetExistingQuestion(
      BuildContext context) async {
    final widgetQuestion = context.getArgument<CloudQuestion>();
    //user can come to this method either by clicking on the note or simply clicking on the plus icon
    //in the latter case there will be widgetNote will be null.

    //If the note exists i.e., user clicked on a note to edit it then we do the following
    if (widgetQuestion != null) {
      _question = widgetQuestion;
      _textController.text = widgetQuestion.text;
      _titleController.text = widgetQuestion.title;
      return widgetQuestion;
    }

    final existingQuestion = _question;
    if (existingQuestion != null) {
      return existingQuestion;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newQuestion =
        await _questionsService.createNewQuestion(ownerUserId: userId);
    _question = newQuestion;
    return newQuestion;
  }

  void _deleteQuestionIfTitleIsEmpty() {
    final question = _question;
    final title = _titleController.text;
    if (title.isEmpty && question != null) {
      _questionsService.deleteQuestion(documentId: question.documentId);
    }
  }

  void _saveQuestionIfTitleNotEmpty() async {
    final question = _question;
    final text = _textController.text;
    final title = _titleController.text;
    if (title.isNotEmpty && question != null) {
      await _questionsService.updateQuestion(
        documentId: question.documentId,
        title: title,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteQuestionIfTitleIsEmpty();
    _saveQuestionIfTitleNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Question'),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_question == null || text.isEmpty) {
                await showCannotShareEmptyQuestionDialog(context);
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
              future: createOrGetExistingQuestion(context),
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
                              hintText: 'Write your Question',
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
                              hintText: 'Your thoughts...',
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
