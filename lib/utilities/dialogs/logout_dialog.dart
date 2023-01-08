import 'package:flutter/material.dart';
import 'package:mynotes1/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
  //then means if value is null which can be due to user pressing back button
  //so return false
  //Future is used because the response depends on the user and not us... It is not instant or pre-determined.
}
