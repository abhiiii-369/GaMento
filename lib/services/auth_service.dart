import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

final FirebaseAuth auth =
FirebaseAuth.instance;

final GoogleSignIn googleSignIn =
GoogleSignIn.instance;

Future<User?> signIn() async {

await googleSignIn.initialize();

final GoogleSignInAccount googleUser =
await googleSignIn.authenticate();

final googleAuth =
googleUser.authentication;

final credential =
GoogleAuthProvider.credential(
idToken: googleAuth.idToken,
);

UserCredential userCredential =
await auth.signInWithCredential(
credential
);

return userCredential.user;

}

Future<void> logout() async {

await auth.signOut();

await googleSignIn.disconnect();

}

}