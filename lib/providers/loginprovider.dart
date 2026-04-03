import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/views/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginprovider extends ChangeNotifier{
  bool isChecked = false;
  bool isPasswordHidden = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Usermodel> userList = [];

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
  void toggleRemember(){
    isChecked = !isChecked;
    notifyListeners();
  }
  void togglePassword(){
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  Future<bool> login() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = userCredential.user;

      if (user != null) {
        print("Login success: ${user.email}");

        if (isChecked) {
          await prefs.setString("email", emailController.text);
          // await prefs.setString('password', passwordController.text);
          await prefs.setBool('remember', true);
        } else {
          await prefs.clear();

        }
        final doc = await _firestore
            .collection("USERS")
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          await createUserInDatabase(user);
        }else{
          print("User already exists in Firestore");
        }
        return true;
      }
    }on FirebaseAuthException catch (e) {
      print("Login success: ${e.message}");
    }
    return false;
  }
  Future<void> createUserInDatabase(User user) async{
    await _firestore.collection("USERS").doc(user.uid).set({
      'email': user.email,
      'createAt': Timestamp.now(),
    });
    // print('User created in database');
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
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}