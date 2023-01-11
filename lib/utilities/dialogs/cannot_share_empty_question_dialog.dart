import 'package:flutter/material.dart';
import 'package:mynotes1/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyQuestionDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty question!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
