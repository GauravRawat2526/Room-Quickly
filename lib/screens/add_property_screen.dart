import 'package:flutter/material.dart';

class AddPropertyScreen extends StatefulWidget {
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Property',
      )),
      body: SingleChildScrollView(),
    );
  }
}
