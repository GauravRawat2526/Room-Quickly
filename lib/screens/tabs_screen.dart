import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:room_quickly/models/user_data.dart';
import 'package:room_quickly/screens/chat_screen.dart';
import 'package:room_quickly/screens/pg_hostel_screen.dart';
import 'package:room_quickly/screens/rooms_screen.dart';
import '../widgets/app_drawer.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _scrAndName;
  int _selectedPageIndex = 0;
  var isLoading = true;
  @override
  void initState() {
    _scrAndName = [
      {'screen': PgHostelScreen(), 'name': 'PgHostelScreen'},
      // {'screen': SearchScreen(), 'name': 'Favourites'},
      // {'screen': AddRoom(), 'name': 'StatusScreen'},
      {'screen': RoomsScreen(), 'name': 'RoomsScreen'},
      {'screen': ChatScreen(), 'name': 'ChatScreen'},
      // {'screen': StatusScreen(), 'name': 'StatusScreen'},
    ];
    getUserName().then((userName) {
      print(userName);
      getUserDataByUserName(userName).then((userData) {
        Provider.of<UserData>(context, listen: false).setUserData(
            userData['userName'],
            userData['name'],
            userData['imageUrl'],
            userData['phoneNumber'],
            userData['email'],
            userData['upid'],);
        setState(() {
          isLoading = false;
        });
      });
    });

    super.initState();
  }

  Future<String> getUserName() async {
    return await FireStoreService.getUserNameById(
        FirebaseAuth.instance.currentUser.uid);
  }

  Future getUserDataByUserName(String userName) async {
    return await FireStoreService.getUserDataByUserName(userName);
  }

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Room Quickly',
        ),
        elevation: 0,
      ),
      drawer: isLoading ? null : AppDrawer(),
      body: isLoading
          ? SpinKitWave(color: Theme.of(context).primaryColor)
          : _scrAndName[_selectedPageIndex]['screen'],
      bottomNavigationBar: CurvedNavigationBar(
          index: _selectedPageIndex,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          items: [
            Tab(
              icon: Image.asset(
                "assets/images/hostel.png",
                height: 30,
                color: Colors.white,
              ),
            ),
            Tab(
              icon: Image.asset(
                "assets/images/room.png",
                height: 30,
                color: Colors.white,
              ),
            ),
            Icon(
              MdiIcons.commentTextMultiple,
              color: Colors.white,
            ),
            // Icon(
            //   Icons.group,
            //   color: Colors.white,
            // ),
            //   Icon(
            //     MdiIcons.magnify,
            //     color: Colors.white,
            //   ),
            //   Icon(
            //     MdiIcons.wallpaper,
            //     color: Colors.white,
            //   ),
            //
          ],
          onTap: selectPage),
    );
  }
}
