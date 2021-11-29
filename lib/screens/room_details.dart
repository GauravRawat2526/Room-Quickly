import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_quickly/models/user_data.dart';
import 'package:room_quickly/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetails extends StatefulWidget {
  static const routeName = '/roomDetails';
  final String cityName;
  final facility;
  final type;
  final address;
  final email;
  final roomName;
  final photos;
  final price;
  final userName;
  final phoneNumber;

  RoomDetails(
      {Key key,
      this.cityName,
      this.facility,
      this.type,
      this.address,
      this.email,
      this.roomName,
      this.photos,
      this.price,
      this.userName,
      this.phoneNumber})
      : super(key: key);

  @override
  _RoomDetailsState createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  var isLoading = false;

  createChatRoom(BuildContext context) async {
    final myName = Provider.of<UserData>(context, listen: false).userName;
    List<String> users = [widget.userName, myName];
    Map<String, dynamic> chatRoomMap = {
      'chatRoomId': '${widget.userName}@$myName',
      'users': users
    };
    setState(() {
      isLoading = true;
    });
    await FireStoreService.createChatRoom(chatRoomMap);
    setState(() {
      isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                height: 150,
                width: double.infinity,
                child: Center(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.photos.length,
                      itemBuilder: (_, index) {
                        return Container(
                          width: 250,
                          height: 250,
                          child: Card(
                            child: Image.network(
                              widget.photos[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Address',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    width: 55,
                  ),
                  Text(
                    widget.address,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Owner email',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    widget.email,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    widget.phoneNumber,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Price',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'RS ${widget.price}',
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
              Text(
                'Facilities',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Container(
                constraints: BoxConstraints(minHeight: 200, maxHeight: 300),
                child: GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 3,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(widget.facility.length, (index) {
                    return Container(
                      width: 200,
                      height: 200,
                      child: Card(
                        child: Image.asset(
                          'assets/images/${widget.facility[index]}.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (widget.userName !=
                  Provider.of<UserData>(context, listen: false).userName)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              createChatRoom(context);
                            },
                            child: Text('Chat With Owner')),
                    SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          initiateTransaction();
                        },
                        child: Text('Book'))
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  initiateTransaction() async {
    String upi_url =
        'upi://pay?pa=ayushyadav685@okicici&pn=${widget.userName}&am=${widget.price}&cu=INR';
    await launch(upi_url).then((value) {
      print(value);
    }).catchError((err) => print(err));
    await FireStoreService.bookRoom(
        Provider.of<UserData>(context, listen: false).userName,
        widget.roomName,
        widget.price,
        widget.photos);
  }
}
