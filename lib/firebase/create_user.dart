// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class CreateUserServices {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<UserCredential> createUserWithEmail({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     final credential = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     await credential.user!.updateDisplayName(name);

//     // Explicitly pass name for Firestore entry
//     await _createLedger(user: credential.user!, name: name);
//     return credential;
//   }

//   Future<UserCredential?> signInWithGoogle() async {
//     final googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) return null;

//     final googleAuth = await googleUser.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final userCredential = await _auth.signInWithCredential(credential);
//     await _createLedger(
//       user: userCredential.user!,
//       name: userCredential.user!.displayName ?? '',
//     );
//     return userCredential;
//   }

//   Future<UserCredential?> signInWithFacebook() async {
//     final result = await FacebookAuth.instance.login();
//     if (result.status == LoginStatus.success) {
//       final credential =
//           FacebookAuthProvider.credential(result.accessToken!.tokenString);
//       final userCredential = await _auth.signInWithCredential(credential);
//       await _createLedger(
//         user: userCredential.user!,
//         name: userCredential.user!.displayName ?? '',
//       );
//       return userCredential;
//     }
//     throw FirebaseAuthException(code: 'FACEBOOK_SIGN_IN_FAILED');
//   }

//   Future<void> _createLedger({
//     required User user,
//     required String name,
//   }) async {
//     final doc = _firestore.collection('ledgers').doc(user.email);
//     final snapshot = await doc.get();

//     if (!snapshot.exists) {
//       await doc.set({
//         'name': name,
//         'admin': false,
//         'firstLogin': FieldValue.serverTimestamp(), // ✅ Secure server time
//       });
//     }
//   }

//   Future<bool> isTrialExpired(String email) async {
//     final doc = await _firestore.collection('ledgers').doc(email).get();
//     if (!doc.exists || doc['firstLogin'] == null) return true;

//     final Timestamp ts = doc['firstLogin'];
//     final firstLogin = ts.toDate(); // ✅ Server-based time
//     final now = DateTime.now().toUtc();

//     return now.difference(firstLogin).inMinutes >= 2;
//   }
// }
