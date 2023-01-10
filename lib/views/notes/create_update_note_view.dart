import 'package:flutter/material.dart';
import 'package:mynotes1/services/auth/auth_service.dart';
import 'package:mynotes1/services/cloud/cloud_note.dart';
import 'package:mynotes1/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes1/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes1/utilities/generics/get_arguments.dart';
import 'package:mynotes1/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  //_note to keep track of the note... so a new note isn't created everytime build method is called
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  //to keep track of the input the user is entering.
  late final TextEditingController _textController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
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

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    //user can come to this method either by clicking on the note or simply clicking on the plus icon
    //in the latter case there will be widgetNote will be null.

    //If the note exists i.e., user clicked on a note to edit it then we do the following
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      _titleController.text = widgetNote.title;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    final text = _textController.text;
    if (text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    final title = _titleController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        documentId: note.documentId,
        title: title,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
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
              future: createOrGetExistingNote(context),
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
                              hintText: 'Start typing your note...',
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
