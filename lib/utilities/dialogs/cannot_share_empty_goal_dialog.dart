import 'package:flutter/material.dart';
import 'package:mynotes1/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyGoalDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty goal!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
