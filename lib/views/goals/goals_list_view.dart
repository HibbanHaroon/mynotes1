import 'package:flutter/material.dart';
import 'package:mynotes1/services/cloud/goals/cloud_goal.dart';
import 'package:mynotes1/utilities/dialogs/delete_diallog.dart';

typedef GoalCallback = void Function(CloudGoal);

class GoalsListView extends StatelessWidget {
  //what is an iterable
  final Iterable<CloudGoal> goals;
  final GoalCallback onDeleteGoal;
  final GoalCallback onTap;
  const GoalsListView({
    Key? key,
    required this.goals,
    required this.onDeleteGoal,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        itemCount: goals.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          final goal = goals.elementAt(index);
          return Card(
            elevation: 5,
            color: const Color(0xffddf0dd),
            child: InkWell(
              onLongPress: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteGoal(goal);
                }
              },
              onTap: () {
                onTap(goal);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      goal.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      goal.text,
                      maxLines: 7,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
