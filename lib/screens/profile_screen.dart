import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:room_quickly/services/blocs.dart';
import 'package:room_quickly/services/firestore_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:room_quickly/models/user_data.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _imageFile;
  String _uploadFileURL;
  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  final _userName = new TextEditingController();
  final _fullName = new TextEditingController();
  final _emailUser = new TextEditingController();
  final _upidName = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<Blocs>(context);
    final userData = Provider.of<UserData>(context);
    _uploadFileURL = userData.imageUrl;
    _userName.text = userData.userName;
    _fullName.text = userData.name;
    _emailUser.text = userData.email;
    _upidName.text= userData.upid;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Arial Rounded",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Builder(
            builder: (context) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 80.0,
                              backgroundImage: _imageFile == null
                                  ? NetworkImage(userData.imageUrl)
                                  : FileImage(File(_imageFile.path)),
                            ),
                            Positioned(
                              bottom: 20.0,
                              right: 20.0,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) =>
                                          bottomSheet(context)));
                                },
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 160, height: 40),
                        child: loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('upload profile',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Arial Rounded",
                                            fontWeight: FontWeight.bold)),
                                    Icon(Icons.arrow_upward),
                                  ],
                                ),
                                onPressed: () async {
                                  setState(() => loading = true);
                                  await uploadPic(context, userData);
                                  // setState(() => loading=false);
                                  print(_uploadFileURL);
                                  print('hello');
                                  print(userData.userName);
                                  print(_emailUser.text);
                                  print(_fullName.text);
                                  userData.setUserData(
                                      _userName.text,
                                      _fullName.text,
                                      _uploadFileURL,
                                      userData.phoneNumber,
                                      _emailUser.text,
                                      _upidName.text);
                                  FireStoreService.addUser(
                                      _userName.text,
                                      _emailUser.text,
                                      _fullName.text,
                                      _upidName.text,
                                      userData.phoneNumber,
                                      _uploadFileURL);
                                  setState(() => loading = false);
                                  Navigator.of(context).pop();
                                  showToastNow();
                                },
                              ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Container(
                                  child: Text("User Name\n${userData.userName}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "Arial Rounded",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.perm_contact_cal_rounded,
                                  color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Container(
                                  child: Text("Name\n${userData.name}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "Arial Rounded",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder:(context){ return userBottomSheet(
                                        context, bloc, userData);});
                              },
                              child: Icon(
                                MdiIcons.pen,
                                color: Colors.purple,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  MdiIcons.email,
                                  color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Container(
                                  child: Text("Email\n${userData.email}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "Arial Rounded",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {return emailBottomSheet(
                                        context, bloc, userData);});
                              },
                              child: Icon(
                                MdiIcons.pen,
                                color: Colors.purple,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  MdiIcons.idCard,
                                  color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Container(
                                  child: Text("UPI ID\n${userData.upid}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "Arial Rounded",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  Widget emailBottomSheet(BuildContext context, Blocs bloc, UserData userData) {
    return Padding(
      padding:MediaQuery.of(context).viewInsets,
      child: Container(
          height: 260.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Edit Email',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Arial Rounded",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              emailField(bloc, userData),
            ],
          )),
    );
  }

  Widget upidBottomSheet(BuildContext context, Blocs bloc, UserData userData) {
    return Container(
        height: 260.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Edit UPI ID',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Arial Rounded",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            upidField(bloc, userData),
          ],
        ));
  }

  Widget userBottomSheet(BuildContext context, Blocs bloc, UserData userData) {
    return Padding(
      padding:MediaQuery.of(context).viewInsets,
      child: Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: <Widget>[
              Text(
                'Edit About User',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Arial Rounded",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              nametextField(bloc, userData),
            ],
          )),
    );
  }

  Widget nametextField(Blocs bloc, UserData userData) {
    return StreamBuilder<Object>(
        stream: bloc.fullName,
        builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                child: TextFormField(
                  controller: _fullName,
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
                      Icons.person,
                      color: Colors.purple,
                    ),
                    labelText: "Name",
                    //helperText: "User Name can't empty",
                    hintText: "Name",
                    errorText: snapshot.error,
                  ),
                  onChanged: bloc.changeFullName,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 140, height: 50),
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Confirm', style: TextStyle(fontSize: 18)),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                    onPressed: snapshot.hasError
                        ? null
                        : () {
                            //setState(() => loading=true);
                            //await uploadPic(context,userData);
                            // setState(() => loading=false);
                            print(_uploadFileURL);
                            print('hello');
                            print(userData.userName);
                            print(_emailUser.text);
                                print(_fullName.text);
                                userData.setUserData(
                                    _userName.text,
                                    _fullName.text,
                                    _uploadFileURL,
                                    userData.phoneNumber,
                                    _emailUser.text,
                                    _upidName.text);
                                FireStoreService.addUser(
                                    _userName.text,
                                    _emailUser.text,
                                    _fullName.text,
                                    _upidName.text,
                                    userData.phoneNumber,
                                    _uploadFileURL);
                                setState(() => loading = false);
                                Navigator.of(context).pop();
                                showToastNow();
                          },
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget emailField(Blocs bloc, UserData userData) {
    return StreamBuilder<Object>(
        stream: bloc.emailUser,
        builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                child: TextFormField(
                  controller: _emailUser,
                  maxLines: 2,
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
                      MdiIcons.email,
                      color: Colors.purple,
                    ),
                    labelText: "Email",
                    hintText: "Email",
                    errorText: snapshot.error,
                  ),
                  onChanged: bloc.changeEmailUser,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 140, height: 50),
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Confirm', style: TextStyle(fontSize: 18)),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                    onPressed: snapshot.hasError
                        ? null
                        : () {
                            print(_uploadFileURL);
                            print('hello');
                            print(userData.userName);
                            print(_emailUser.text);
                                print(_fullName.text);
                                userData.setUserData(
                                    _userName.text,
                                    _fullName.text,
                                    _uploadFileURL,
                                    userData.phoneNumber,
                                    _emailUser.text,
                                    _upidName.text);
                                FireStoreService.addUser(
                                    _userName.text,
                                    _emailUser.text,
                                    _fullName.text,
                                    _upidName.text,
                                    userData.phoneNumber,
                                    _uploadFileURL);
                                setState(() => loading = false);
                                Navigator.of(context).pop();
                                showToastNow();
                          },
                  ),
                ),
              ),
            ],
          );
        });
  }


  Widget upidField(Blocs bloc, UserData userData) {
    return StreamBuilder<Object>(
        stream: bloc.upidName,
        builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                child: TextFormField(
                  controller: _upidName,
                  maxLines: 4,
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
                      MdiIcons.alertCircleOutline,
                      color: Colors.purple,
                    ),
                    labelText: "UPI ID",
                    //helperText: "About field can't empty",
                    hintText: "UPI ID",
                    errorText: snapshot.error,
                  ),
                  onChanged: bloc.changeUpidName,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 140, height: 50),
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Confirm', style: TextStyle(fontSize: 18)),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                    onPressed: snapshot.hasError
                        ? null
                        : () {
                            //setState(() => loading=true);
                            // await uploadPic(context,userData);
                            // setState(() => loading=false);
                            print(_uploadFileURL);
                            print('hello');
                            print(userData.userName);
                            print(_emailUser.text);
                                print(_fullName.text);
                                userData.setUserData(
                                    _userName.text,
                                    _fullName.text,
                                    _uploadFileURL,
                                    userData.phoneNumber,
                                    _emailUser.text,
                                    _upidName.text);
                                FireStoreService.addUser(
                                    _userName.text,
                                    _emailUser.text,
                                    _fullName.text,
                                    _upidName.text,
                                    userData.phoneNumber,
                                    _uploadFileURL);
                                setState(() => loading = false);
                                Navigator.of(context).pop();
                                showToastNow();
                          },
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Choose Profile photo',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Arial Rounded",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: Text('Camera',
                      style: TextStyle(
                        fontFamily: "Arial Rounded",
                      )),
                ),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text('Gallery',
                      style: TextStyle(
                        fontFamily: "Arial Rounded",
                      )),
                )
              ],
            )
          ],
        ));
  }

  void takePhoto(ImageSource source) async {
    print(source);
    final pickerFile = await _picker.getImage(source: source, imageQuality: 50);
    setState(() {
      _imageFile = File(pickerFile.path);
    });
    print(_imageFile);
    print(_imageFile.path);
  }

  Future uploadPic(BuildContext context, UserData userData) async {
    try {
      String fileName = basename(_imageFile.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      var url = await (await uploadTask).ref.getDownloadURL();
      _uploadFileURL = url.toString();
      print(_uploadFileURL);
    } catch (error) {
      _uploadFileURL = userData.imageUrl;
    }
  }

  showToastNow() {
    Fluttertoast.showToast(
        msg: "Profile Updated",
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey[700],
        gravity: ToastGravity.BOTTOM);
  }
}
