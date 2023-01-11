import 'package:flutter/material.dart';
import 'package:mynotes1/services/cloud/questions/cloud_question.dart';
import 'package:mynotes1/utilities/dialogs/delete_diallog.dart';

typedef QuestionCallback = void Function(CloudQuestion);

class QuestionsListView extends StatelessWidget {
  //what is an iterable
  final Iterable<CloudQuestion> questions;
  final QuestionCallback onDeleteQuestion;
  final QuestionCallback onTap;
  const QuestionsListView({
    Key? key,
    required this.questions,
    required this.onDeleteQuestion,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffddf0dd), // Your desired background color
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2), blurRadius: 2),
                  ]),
              child: ListTile(
                tileColor: const Color(0xffddf0dd),
                leading: const Icon(Icons.question_mark),
                title: Text(
                  question.title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                onLongPress: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteQuestion(question);
                  }
                },
                onTap: () {
                  onTap(question);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
