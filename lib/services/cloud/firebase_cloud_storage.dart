import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes1/services/cloud/goals/cloud_goal.dart';
import 'package:mynotes1/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes1/services/cloud/notes/cloud_note.dart';
import 'package:mynotes1/services/cloud/questions/cloud_question.dart';
import 'package:mynotes1/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  //grabbing all the notes from the collection 'notes'
  final notes = FirebaseFirestore.instance.collection('notes');
  final goals = FirebaseFirestore.instance.collection('goals');
  final questions = FirebaseFirestore.instance.collection('questions');

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      title: '',
      text: '',
    );
  }

  Future<CloudGoal> createNewGoal({required String ownerUserId}) async {
    final document = await goals.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      textFieldName: '',
    });
    final fetchedGoal = await document.get();
    return CloudGoal(
      documentId: fetchedGoal.id,
      ownerUserId: ownerUserId,
      title: '',
      text: '',
    );
  }

  Future<CloudQuestion> createNewQuestion({required String ownerUserId}) async {
    final document = await questions.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      textFieldName: '',
    });
    final fetchedQuestion = await document.get();
    return CloudQuestion(
      documentId: fetchedQuestion.id,
      ownerUserId: ownerUserId,
      title: '',
      text: '',
    );
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    //get notes of the current user and not all the notes of all the users.
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudNote.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<Iterable<CloudGoal>> getGoals({required String ownerUserId}) async {
    //get notes of the current user and not all the notes of all the users.
    try {
      return await goals
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudGoal.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllGoalsException();
    }
  }

  Future<Iterable<CloudQuestion>> getQuestions(
      {required String ownerUserId}) async {
    //get notes of the current user and not all the notes of all the users.
    try {
      return await questions
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudQuestion.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllQuestionsException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Stream<Iterable<CloudGoal>> allGoals({required String ownerUserId}) =>
      goals.snapshots().map((event) => event.docs
          .map((doc) => CloudGoal.fromSnapshot(doc))
          .where((goal) => goal.ownerUserId == ownerUserId));

  Stream<Iterable<CloudQuestion>> allQuestions({required String ownerUserId}) =>
      questions.snapshots().map((event) => event.docs
          .map((doc) => CloudQuestion.fromSnapshot(doc))
          .where((question) => question.ownerUserId == ownerUserId));

  Future<void> updateNote({
    required String documentId,
    required String title,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> updateGoal({
    required String documentId,
    required String title,
    required String text,
  }) async {
    try {
      await goals.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateGoalException();
    }
  }

  Future<void> updateQuestion({
    required String documentId,
    required String title,
    required String text,
  }) async {
    try {
      await questions.doc(documentId).update({
        titleFieldName: title,
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateQuestionException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteGoal({
    required String documentId,
  }) async {
    try {
      await goals.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteGoalException();
    }
  }

  Future<void> deleteQuestion({
    required String documentId,
  }) async {
    try {
      await questions.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteQuestionException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  //This is a private constructor of the class FirebaseCloudStorage
  FirebaseCloudStorage._sharedInstance();
  //This is a factory constructor which will talk with the private static field above,
  //which in turns calls the above private constructor.

  //This is how we make this class a singleton
  factory FirebaseCloudStorage() => _shared;
}
