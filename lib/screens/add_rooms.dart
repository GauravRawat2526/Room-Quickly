import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:room_quickly/models/user_data.dart';
import 'package:room_quickly/screens/tabs_screen.dart';
import 'package:room_quickly/services/blocs.dart';

class AddRoom extends StatefulWidget {
  static const routeName = "/AddRoom";
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  static final _firestore = FirebaseFirestore.instance;
  String _uploadFileURL;
  int index = 0;
  List<dynamic> address = new List();
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  List<File> _image = [];
  final picker = ImagePicker();
  var _currentItemSelected;
  var _currentCitySelected;
  var listItem = ["PGs and Hostels", "Rooms"];
  var listCity = [
    "Bhopal",
    "Dewas",
    "Dhar",
    "Gwalior",
    "Indore",
    "Jabalpur",
    "Ujjain"
  ];
  final allFacility = [];
  final allChecked = CheckBoxModal(title: 'All Facilities');
  final checkBoxList = [
    CheckBoxModal(title: 'Wifi'),
    CheckBoxModal(title: 'BreakFast'),
    CheckBoxModal(title: 'Lunch'),
    CheckBoxModal(title: 'Dinner'),
    CheckBoxModal(title: 'Parking'),
    CheckBoxModal(title: 'CCTV'),
    CheckBoxModal(title: 'Security'),
    CheckBoxModal(title: 'House Keeping'),
    CheckBoxModal(title: 'Drinking Water'),
  ];
  final _address = new TextEditingController();
  final _amount = new TextEditingController();
  final _name = new TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    //_currentItemSelected=listItem[0];
    String id = createCryptoRandomString();
    final mediaQuery = MediaQuery.of(context);
    final bloc = Provider.of<Blocs>(context);
    final userData = Provider.of<UserData>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Room'),
        ),
        body: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        hint: Text("Select type:"),
                        items: listItem.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem));
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            _currentItemSelected = newValueSelected;
                            print(_currentItemSelected);
                          });
                        },
                        value: _currentItemSelected,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    nameField(bloc),
                    SizedBox(
                      height: 20,
                    ),
                    addressField(bloc),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        hint: Text("Select The City Name:"),
                        items: listCity.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem));
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            _currentCitySelected = newValueSelected;
                            print(_currentCitySelected);
                          });
                        },
                        value: _currentCitySelected,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Add photos",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Arial Rounded",
                      ),
                    ),
                    Stack(
                      children: [
                        GridView.builder(
                            shrinkWrap: true,
                            itemCount: _image.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Center(
                                      child: IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () => !uploading
                                              ? chooseImage()
                                              : null))
                                  : Container(
                                      margin: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  FileImage(_image[index - 1]),
                                              fit: BoxFit.cover)),
                                    );
                            }),
                        uploading
                            ? Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    SpinKitWave(
                                        color: Theme.of(context).primaryColor),
                                    Text('Wait for a moment',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1)
                                  ]))
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Add Facilities",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Arial Rounded",
                      ),
                    ),
                    ListTile(
                      onTap: () => onAllClicked(allChecked),
                      leading: Checkbox(
                        value: allChecked.value,
                        onChanged: (value) => onAllClicked(allChecked),
                      ),
                      title: Text(allChecked.title),
                    ),
                    Divider(),
                    ...checkBoxList
                        .map(
                          (item) => ListTile(
                            onTap: () => onItemClicked(item),
                            leading: Checkbox(
                              value: item.value,
                              onChanged: (value) => onItemClicked(item),
                            ),
                            title: Text(item.title),
                          ),
                        )
                        .toList(),
                    SizedBox(
                      height: 20,
                    ),
                    amountField(bloc),
                    SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: mediaQuery.size.width, height: 50),
                        child: StreamBuilder<Object>(
                            stream: bloc.addValid,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Confirm',
                                        style: TextStyle(fontSize: 18)),
                                    Icon(Icons.navigate_next)
                                  ],
                                ),
                                onPressed: !snapshot.hasData
                                    ? null
                                    : () async {
                                        setState(() {
                                          loading = true;
                                          checkBoxList.forEach((element) {
                                            if (element.value) {
                                              allFacility.add(element.title);
                                            }
                                          });
                                          uploading = true;
                                          print(allFacility);
                                        });
                                        await uploadPic(context);
                                        await _firestore
                                            .collection('users')
                                            .doc(userData.userName)
                                            .collection('participant')
                                            .doc(id)
                                            .set({
                                          'CityName': _currentCitySelected,
                                          'Type': _currentItemSelected,
                                          'address': _address.text,
                                          'name': _name.text,
                                          'Facility': allFacility,
                                          'id': id,
                                          'photos': address,
                                          'userName': userData.userName,
                                          'price': _amount.text,
                                          'email': userData.email,
                                          'userPhone': userData.phoneNumber,
                                        });
                                        print(_amount);
                                        print(userData.phoneNumber);
                                        await _firestore
                                            .collection(_currentItemSelected)
                                            .doc(_currentCitySelected)
                                            .collection(
                                                '${_currentCitySelected}Details')
                                            .doc(id)
                                            .set({
                                          'CityName': _currentCitySelected,
                                          'Type': _currentItemSelected,
                                          'Facility': allFacility,
                                          'address': _address.text,
                                          'name': _name.text,
                                          'photos': address,
                                          'userName': userData.userName,
                                          'price': _amount.text,
                                          'email': userData.email,
                                          'userPhone': userData.phoneNumber,
                                        }); //.whenComplete(() => Navigator.of(context).pushReplacement(
                                        //MaterialPageRoute(builder: (ctx) => AddRoom())));
                                        setState(() {
                                          loading = false;
                                        });
                                        //Navigator.of(context).pop();
                                        showToastNow();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    TabsScreen()));
                                      },
                              );
                            }))
                  ],
                )),
            if (loading && uploading)
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    SpinKitWave(color: Theme.of(context).primaryColor),
                    Text('Wait for a moment',
                        style: Theme.of(context).textTheme.bodyText1)
                  ])),
          ],
        ));
  }

  onAllClicked(CheckBoxModal ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;
      checkBoxList.forEach((element) {
        element.value = newValue;
      });
    });
  }

  onItemClicked(CheckBoxModal ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;
      if (!newValue) {
        allChecked.value = false;
      } else {
        final allListChecked = checkBoxList.every((element) => element.value);
        allChecked.value = allListChecked;
      }
    });
  }

  Widget amountField(Blocs bloc) {
    return StreamBuilder<Object>(
        stream: bloc.amount,
        builder: (context, snapshot) {
          return TextFormField(
            controller: _amount,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.monetization_on,
                color: Colors.purple,
              ),
              labelText: "Amount",
              // helperText: "Name can't empty",
              hintText: "Amount",
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeAddress,
          );
        });
  }

  Widget addressField(Blocs bloc) {
    return StreamBuilder<Object>(
        stream: bloc.address,
        builder: (context, snapshot) {
          return TextFormField(
            controller: _address,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.home,
                color: Colors.purple,
              ),
              labelText: "Address",
              // helperText: "Name can't empty",
              hintText: "Address",
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeAddress,
          );
        });
  }

  Widget nameField(Blocs bloc) {
    return StreamBuilder<Object>(
        stream: bloc.fullName,
        builder: (context, snapshot) {
          return TextFormField(
            controller: _name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.language_sharp,
                color: Colors.purple,
              ),
              labelText: "PG/Hostel/Room Name",
              // helperText: "Name can't empty",
              hintText: "PG/Hostel/Room Name",
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeFullName,
          );
        });
  }

  chooseImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    // ignore: deprecated_member_use
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadPic(BuildContext context) async {
    for (var img in _image) {
      try {
        String fileName = basename(img.path);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = firebaseStorageRef.putFile(img);
        var url = await (await uploadTask).ref.getDownloadURL();
        _uploadFileURL = url.toString();
        setState(() {
          address.add(_uploadFileURL);
        });
        print(_uploadFileURL);
      } catch (error) {
        _uploadFileURL = 'https://img.icons8.com/officel/2x/person-male.png';
      }
    }
  }

  String createCryptoRandomString([int length = 32]) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  showToastNow() {
    Fluttertoast.showToast(
        msg: "Added Successfully",
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey[700],
        gravity: ToastGravity.BOTTOM);
  }
}

class CheckBoxModal {
  String title;
  bool value;
  CheckBoxModal({@required this.title, this.value = false});
}
