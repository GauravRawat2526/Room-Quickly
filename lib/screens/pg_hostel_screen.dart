import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_quickly/widgets/rooms_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firestore_service.dart';

class PgHostelScreen extends StatefulWidget {
  @override
  _PgHostelScreenState createState() => _PgHostelScreenState();
}

class _PgHostelScreenState extends State<PgHostelScreen> {
  var isLoading = false;
  final _searchFieldController = TextEditingController();
  var snapShot;
  var city = 'Indore';
  // initiateTransaction() async {
  //   String upi_url =
  //       'upi://pay?pa=ayushyadav685@okicici&pn=Ayush Yadav&am=1&cu=INR';
  //   await launch(upi_url).then((value) {
  //     print(value);
  //   }).catchError((err) => print(err));
  // }

  Widget roomList() {
    return ListView.builder(
      itemCount: snapShot.docs.length,
      itemBuilder: (ctx, index) {
        return RoomsTile(
          userName: snapShot.docs[index]['userName'],
          cityName: snapShot.docs[index]['CityName'],
          facility: snapShot.docs[index]['Facility'],
          type: snapShot.docs[index]['Type'],
          address: snapShot.docs[index]['address'],
          email: snapShot.docs[index]['email'],
          name: snapShot.docs[index]['name'],
          photos: snapShot.docs[index]['photos'],
          price: snapShot.docs[index]['price'],
          phoneNumber: snapShot.docs[index]['userPhone'],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                    autocorrect: false,
                    controller: _searchFieldController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Enter City Name',
                      hintStyle: Theme.of(context).textTheme.bodyText1,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColorLight,
                            width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    )),
              ),
            ),
            Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).primaryColor,
                ),
                child: IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      city = _searchFieldController.text;
                      snapShot = await FireStoreService.getPgByCity(city);
                      setState(() {
                        isLoading = false;
                      });
                    }))
          ],
        ),
        isLoading
            ? SpinKitWave(color: Theme.of(context).primaryColor)
            : Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: snapShot == null
                    ? Text(
                        'Search By City',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    : roomList())
      ]),
    );
  }
}
