import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram/services/pref.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User _user = _auth.currentUser!;
      return _user;
    } catch (error) {
      print(error);
    }
    return null;
  }

  static Future<User?> signUp(String email, String password) async {
    try {
      UserCredential _signUpResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return _signUpResult.user;
    } catch (error) {
      print(error);
    }
  }

  static Future logout() async {
    await _auth.signOut();
    await Pref.removeId();
  }
}
