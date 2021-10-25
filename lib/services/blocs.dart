
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class Blocs{
  final _userName= BehaviorSubject<String>();//use to store the latest value
  final _emailUser = BehaviorSubject<String>();
  final _fullName = BehaviorSubject<String>();
  final _address= BehaviorSubject<String>();
  final _upidName= BehaviorSubject<String>();
  final _amount= BehaviorSubject<String>();
  static final _firestore = FirebaseFirestore.instance;
  
  //Get
  Stream<String> get userName=>_userName.stream.transform(validateUserName); //to access the variable
  Stream<String> get emailUser=>_emailUser.stream.transform(validateEmailUser);
  Stream<String> get fullName =>_fullName.stream.transform(validateFullName);
  Stream<String> get address =>_address.stream.transform(validateAddress);
  Stream<double> get amount =>_address.stream.transform(validateAmount);
  Stream<String> get upidName =>_upidName.stream.transform(validateUpidName);
  Stream<bool> get addValid => Rx.combineLatest3(fullName, address, amount, (fullName, address, amount) => true);
  Stream<bool> get userValid => Rx.combineLatest5(userName, emailUser, fullName, address, upidName, (userName, emailUser, fullName, address, upidName) => true);
  Stream<bool> get changeValid => Rx.combineLatest4(emailUser, fullName, address, upidName, (emailUser, fullName, address, upidName) => true);
  //Stream<bool> get invalidName =>Rx.combineLatest( fullName, (fullName) => null);
  
  //Set
  Function(String) get changeUserName => _userName.sink.add;
  Function(String) get changeEmailUser => _emailUser.sink.add;
  Function(String) get changeFullName => _fullName.sink.add;
  Function(String) get changeAddress => _address.sink.add;
  Function(String) get changeUpidName => _upidName.sink.add;
  Function(String) get changeAmount => _amount.sink.add;
  dispose(){
    _userName.close();
    _emailUser.close();
    _fullName.close();
    _address.close();
    _upidName.close();
    _amount.close();
  }

  //Transformers

  final validateUserName = StreamTransformer<String,String>.fromHandlers(
    handleData: (userName,sink) async {
      final documentSnapshot = await _firestore
                      .collection('users')
                      .doc(userName)
                      .get();
      if(userName.length<5){
        sink.addError("UserName must be at least 5 character");
      }
      else if(userName.isEmpty){
        sink.addError("User can't be empty"); 
      }
      else if (documentSnapshot.exists) {
        sink.addError("UserName is already Exists"); 
      } 
      else{
        sink.add(userName);
      }
    }
  );

  final validateAmount = StreamTransformer<String,double>.fromHandlers(
    handleData: (amount,sink) {
      try{
          sink.add(double.parse(amount));
      }catch(error)
      {
        sink.addError('Value must be a number');
      }
    }
  );

  final validateEmailUser = StreamTransformer<String,String>.fromHandlers(
    handleData: (emailUser,sink) {
      if(emailUser.contains('@')&&emailUser.contains('.')&&emailUser.indexOf('@')<emailUser.indexOf('.')){
        sink.add(emailUser);
      }
      else{
        sink.addError("email is Required");
      }
    }
  );

  final validateFullName = StreamTransformer<String,String>.fromHandlers(
    handleData: (fullName,sink){
      if(fullName.isEmpty){
        sink.addError("Name is Required");
      }
      else{
        sink.add(fullName);
      }
    }
  );

  final validateAddress = StreamTransformer<String,String>.fromHandlers(
    handleData: (address,sink){
      if(address.isEmpty){
        sink.addError("Address is Required");
      }
      else{
        sink.add(address);
      }
    }
  );

  final validateUpidName = StreamTransformer<String,String>.fromHandlers(
    handleData: (upidName,sink){
      if(upidName.isEmpty){
        sink.addError("UPI ID is Required");
      }
      else{
        sink.add(upidName);
      }
    }
  );
}

