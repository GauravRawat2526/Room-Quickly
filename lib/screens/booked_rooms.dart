import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:room_quickly/models/user_data.dart';
import 'package:room_quickly/services/firestore_service.dart';
import 'package:room_quickly/widgets/user_chat_tile.dart';

class BookedRooms extends StatefulWidget {
  @override
  _BookedRoomsState createState() => _BookedRoomsState();
}

class _BookedRoomsState extends State<BookedRooms> {
  Stream bookedStream;
  var isLoading = true;
  Widget bookList() {
    try {
      return StreamBuilder(
        stream: bookedStream,
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting)
            return SpinKitWave(color: Theme.of(context).primaryColor);
          return snapShot.hasData
              ? ListView.builder(
                  itemCount: snapShot.data.docs.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapShot.data.docs[index]['photos']),
                      ),
                      title: Text(
                          'Room Name : ${snapShot.data.docs[index]['roomName']}'),
                      subtitle: Text(snapShot.data.docs[index]['price']),
                    );
                  },
                )
              : Container();
        },
      );
    } catch (error) {
      print('ayush');
      return Container();
    }
  }

  @override
  void initState() {
    FireStoreService.getBookedRooms(
            'users', Provider.of<UserData>(context, listen: false).userName)
        .then((value) {
      bookedStream = value;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Rooms'),
      ),
      body: isLoading
          ? SpinKitWave(color: Theme.of(context).primaryColor)
          : bookList(),
    );
  }
}
