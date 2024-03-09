import 'package:chatapp/firebase/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> register(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        databaseService(id: user.uid).updateuser("balaji", email);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
