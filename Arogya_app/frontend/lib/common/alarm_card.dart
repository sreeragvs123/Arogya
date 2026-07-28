import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmCard extends StatelessWidget {

  final int index;
  final String time;
  final void Function(BuildContext context) onDelete;
  final void Function() onTap;
  final bool isToggle;
  final void Function(bool,int) onToggle;
  
  AlarmCard({
    super.key,
    required this.index,
    required this.time,
    required this.onDelete,
    required this.onTap,
    required this.isToggle,
    required this.onToggle
  });

@override
Widget build(BuildContext context) {
  Color color = isToggle ? Colors.black : const Color.fromARGB(255, 126, 126, 126);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    child: DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Slidable(
          endActionPane: ActionPane(
            motion: StretchMotion(),
            extentRatio: 0.38,
            children: [
              SlidableAction(
                backgroundColor: const Color.fromARGB(255, 173, 0, 0),
                onPressed: onDelete,
                icon: Icons.delete,
              ),
            ],
          ),
          child: Container(
            width: 400,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: InkWell(
                    onTap: onTap,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'ArialBlack',
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Switch(
                    value: isToggle,
                    onChanged: (value) {
                      onToggle(value, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}