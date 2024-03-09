import 'package:cloud_firestore/cloud_firestore.dart';

class databaseService {
  final String? id;
  databaseService({this.id});

  final CollectionReference usercollection =
      FirebaseFirestore.instance.collection('users');

  Future updateuser(String fullname, String email) {
    return usercollection.doc(id).set({
      "fullname": fullname,
      "email": email,
    });
  }
}
