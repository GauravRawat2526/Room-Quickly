import 'package:flutter/material.dart';
import 'package:room_quickly/models/user_data.dart';
import 'package:room_quickly/screens/profile_screen.dart';
import 'package:room_quickly/screens/update_rooms.dart';
import '../services/phone_auth.dart';
// import '../screen/profile_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userData.userName),
            accountEmail: Text(userData.name),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userData.imageUrl),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen()));
            },
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.add_business_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text("Remove hostel/pg/Rooms"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => UpdateRooms()));
            },
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            title: Text('Logout'),
            onTap: () {
              PhoneAuth.logout(context);
            },
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
