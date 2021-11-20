import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:room_quickly/models/user_data.dart';

class UpdateRooms extends StatefulWidget {
  @override
  _UpdateRoomsState createState() => _UpdateRoomsState();
}

class _UpdateRoomsState extends State<UpdateRooms> {
  static final _firestore = FirebaseFirestore.instance;
  List<Model> list = new List();
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    Widget UI(String cityName, String type, String address, String name,
        String price, String id) {
      bool loading =true;
      return Card(
            color: Colors.purple[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)
            ),
            shadowColor: Colors.purple[900],
            child: Column(
              children: <Widget>[
                Text(
                  "Name : ${name}",
                  style: TextStyle(
                      color: Colors.purple,
                      fontFamily: "Arial Rounded",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Price : ${price}",
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Arial Rounded",
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Address : ${address}",
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Arial Rounded",
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "City : ${cityName}",
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Arial Rounded",
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Container(
              margin: EdgeInsets.all(10),
              //padding: EdgeInsets.all(10),
              height: 30.0,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () async {
                  if (loading) Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                SpinKitWave(
                                    color: Theme.of(context).primaryColor),
                                Text('Wait for a moment',
                                    style:
                                        Theme.of(context).textTheme.bodyText1)
                              ]));
                  await _firestore
                  .collection('users')
                  .doc(userData.userName)
                  .collection('participant')
                  .doc(id)
                  .delete();
              await _firestore
                  .collection(type)
                  .doc(cityName)
                  .collection('${cityName}Details')
                  .doc(id)
                  .delete();
                  setState((){
                    loading = false;
            });
             
            Navigator.of(context).pop();
                },
                child: Container(
                  //margin: EdgeInsets.all(0),
                  child: Center(
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Arial Rounded",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
           
              ],
            ),
            
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Remove hostel/pg/Rooms'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: list.length == 0
            ? Center(
                child: Text(
                  "No Rooms added yet",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return UI(
                      list[index].cityName,
                      list[index].type,
                      list[index].address,
                      list[index].name,
                      list[index].price,
                      list[index].id);
                }),
      ),
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    final userData = Provider.of<UserData>(context, listen: false);
    _firestore
        .collection('users')
        .doc(userData.userName)
        .collection('participant')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        Model model = new Model(
            cityName: element['CityName'],
            type: element['Type'],
            address: element['address'],
            name: element['name'],
            price: element['price'],
            id: element['id']);

        setState(() {
          list.add(model);
          // print(element['CityName']);
          // print(element['Type']);
          // print(element['address']);
          // print(element['name']);
          // print(element['price']);
          // print(element['id']);
        });
      });
    });
  }
}

class Model {
  String cityName;
  String type;
  String address;
  String name;
  String price;
  String id;
  Model(
      {this.cityName, this.type, this.address, this.name, this.price, this.id});
}
