import 'package:flutter/material.dart';

class LivseyScreen extends StatelessWidget {
  const LivseyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(child: Text(
          'В следующий раз :,(',
        style: TextStyle(color: Colors.white),
      ),),
    );
  }
}
