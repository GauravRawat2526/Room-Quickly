import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PgHostelScreen extends StatefulWidget {
  @override
  _PgHostelScreenState createState() => _PgHostelScreenState();
}

class _PgHostelScreenState extends State<PgHostelScreen> {
  initiateTransaction() async {
    String upi_url =
        'upi://pay?pa=ayushyadav685@okicici&pn=Ayush Yadav&am=1&cu=INR';
    await launch(upi_url).then((value) {
      print(value);
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text('Pay'),
        onPressed: initiateTransaction,
      ),
    );
  }
}
