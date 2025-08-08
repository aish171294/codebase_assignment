import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/user_model.dart';

class UserRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  UserRemoteDataSource({required this.auth, required this.firestore});

  Future<UserCredential> createUser(String email, String password) async {
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    await firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  @override
  Future<UserCredential> loginUser(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserModel> getUserFromFirestore(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    return UserModel.fromMap(doc.data()!);
  }
}
