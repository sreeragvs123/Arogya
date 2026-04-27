import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color.fromARGB(255, 7, 127, 255),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 18, 255, 243),
                ),
              ),
            SizedBox(height: 20),
            Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 201, 17, 17),
                ),
              ),
              SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}