import 'package:fitness_app/manage_session_screen.dart';
import 'package:flutter/material.dart';

class SelectSessionScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0b0d0f),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF0b0d0f),
        title: Text(
          "Select Session",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ManageSessionScreen()),
          );
        },
      ),
    );
  }
}
