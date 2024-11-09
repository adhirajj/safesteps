import 'package:cloud_firestore/cloud_firestore.dart';

class Person{

  // login info
  String? uid;
  String? email = "";
  String? password = "";
  int? publishedDateTime;

  // contacts
  String? contact1 = "";
  String? contact2 = "";
  String? contact3 = "";
  String? liveLocationContact1 = "";
  String? liveLocationContact2 = "";
  String? liveLocationContact3 = "";

  Person({

    // login info
    this.uid,
    this.email,
    this.password,
    this.publishedDateTime,

    // contacts
    this.contact1,
    this.contact2,
    this.contact3,
    this.liveLocationContact1,
    this.liveLocationContact2,
    this.liveLocationContact3,

  });

  static Person fromdataSnapShot(DocumentSnapshot snapshot){

    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Person(

      // login info
      uid: dataSnapshot["uid"],
      email: dataSnapshot["email"],
      password: dataSnapshot["password"],
      publishedDateTime: dataSnapshot["publishedDateTime"],

      // contacts
      contact1: dataSnapshot["contact1"],
      contact2: dataSnapshot["contact2"],
      contact3: dataSnapshot["contact3"],
      liveLocationContact1: dataSnapshot["liveLocationContact1"],
      liveLocationContact2: dataSnapshot["liveLocationContact2"],
      liveLocationContact3: dataSnapshot["liveLocationContact3"],

    );
  }

  Map<String, dynamic> toJson()=> {

    // login info
    "uid": uid,
    "email": email,
    "password": password,
    "publishedDateTime": publishedDateTime,

    // contacts
    "contact1": contact1,
    "contact2": contact2,
    "contact3": contact3,
    "liveLocationContact1": liveLocationContact1,
    "liveLocationContact2": liveLocationContact2,
    "liveLocationContact3": liveLocationContact3,

  };
}