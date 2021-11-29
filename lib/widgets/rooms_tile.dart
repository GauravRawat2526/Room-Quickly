import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../screens/room_details.dart';

class RoomsTile extends StatelessWidget {
  final String cityName;
  final facility;
  final type;
  final address;
  final email;
  final name;
  final photos;
  final price;
  final userName;
  final phoneNumber;

  const RoomsTile(
      {this.cityName,
      this.facility,
      this.type,
      this.address,
      this.email,
      this.name,
      this.photos,
      this.price,
      this.userName,
      this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          color: Colors.blueAccent[100],
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return RoomDetails(
                  cityName: cityName,
                  facility: facility,
                  type: type,
                  address: address,
                  email: email,
                  roomName: name,
                  photos: photos,
                  price: price,
                  userName: userName,
                  phoneNumber: phoneNumber,
                );
              }));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 300,
              child: Column(
                children: [
                  Container(
                      height: 200,
                      width: 250,
                      margin: EdgeInsets.all(10),
                      child: CarouselSlider.builder(
                          options: CarouselOptions(height: 200.0),
                          itemCount: photos.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Image.network(
                                photos[itemIndex],
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ))),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Text(name, style: Theme.of(context).textTheme.subtitle1),
                      Text('Rs ${price}',
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
