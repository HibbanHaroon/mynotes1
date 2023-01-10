import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes1/services/cloud/cloud_note.dart';
import 'package:mynotes1/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes1/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  //grabbing all the notes from the collection 'notes'
  final notes = FirebaseFirestore.instance.collection('notes');

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

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

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

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
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
