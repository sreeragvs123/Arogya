import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';

class AlarmCard extends StatelessWidget {

  final int index;
  final String hour;
  final String minute;
  final void Function(BuildContext context) onDelete;
  const AlarmCard({super.key,required this.index,required this.hour,required this.minute,required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            icon:Icons.delete
            )
        ],
      ),
      child: Container(
        margin:EdgeInsets.all(20),
        width:300,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alarm ${index+1}",
              style:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              )
            ),
            Text("$hour:$minute",
              style:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:30
              )
            )
          ],
        )
      ),
    );
  }
}