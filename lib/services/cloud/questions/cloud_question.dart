import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes1/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudQuestion {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String text;

  const CloudQuestion({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.text,
  });

//We are taking a snapshot of a note in a document and making a note from it.
  CloudQuestion.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        text = snapshot.data()[textFieldName] as String;
}
