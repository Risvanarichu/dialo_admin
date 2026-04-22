import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/views/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginprovider extends ChangeNotifier{
  bool isChecked = false;
  bool isPasswordHidden = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Usermodel> userList = [];

  Future<bool> login() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      print("Entered Email: ${emailController.text}");
      print("Entered Password: ${passwordController.text}");
      final querySnapshot = await _firestore
          .collection('AGENT')
          .where('EMAIL', isEqualTo: emailController.text.trim().toLowerCase())
          .where('PASSWORD', isEqualTo: passwordController.text.trim())
          .where('ROLE', isEqualTo: 'ADMIN')
          .get();
      print("Docs found: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userMap =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        print("Login Success: ${emailController.text}");

        await prefs.setBool('remember', isChecked);
        await prefs.setString('email', userMap['EMAIL'] ?? '');
        await prefs.setString('password', userMap['PASSWORD'] ?? '');
        await prefs.setString('employeeid', userMap['EMPLOYEEID'] ?? '');
        await prefs.setString('agentId', querySnapshot.docs.first.id);
        await prefs.setString('name', userMap['NAME'] ?? '');
        await prefs.setString('image', userMap['IMAGE'] ?? '');

        await fetchUsers();

        return true;
      } else {
        print("Login Failed: Invalid credentials");
        return false;
      }
    } catch (e) {
      print("Unexpected Error: $e");
      return false;
    }
  }

  Future<User?> signInWithGoogle()async{
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null){
        print("Google Sign-In cancelled");
        return null;
      }
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken:  googleAuth.accessToken,
        idToken:  googleAuth.idToken,
      );

      final userCredential=
       await _auth.signInWithCredential(credential);

       final user = userCredential.user;

      if (user == null ) return null;

      await _saveUserToFirestore(user);
      await fetchUsers();

      print("Google Login Success: ${user.email}");
      return user;
    }catch (e){
      print("Google Error: $e");
      return null;
    }
  }
  Future<void> _saveUserToFirestore(User user) async{
    final docRef = _firestore.collection("USERS").doc(user.uid);

        final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'email' : user.email,
        'uid': user.uid,
        'createdAt' : Timestamp.now(),
      });
      print("User saved");
    }
  }

  Future<void> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection("USERS").get();
      userList = snapshot.docs.map((doc){
        return Usermodel.fromMap(doc.data(), doc.id);
      }).toList();

      print("Usres fetched: ${userList.length}");
      notifyListeners();
    }catch (e) {
      print("Error fetching users: $e");
    }
  }

  void toggleRemember(){
    isChecked = !isChecked;
    notifyListeners();
  }
  void togglePassword(){
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }
    Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    bool remember = prefs.getBool('remember') ?? false;

    if(remember){
      isChecked = true;
      emailController.text = prefs.getString('email') ??'';
      // passwordController.text = prefs.getString("password") ?? '';
    }
    notifyListeners ();
  }

  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}









