import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialo_admin/views/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginprovider extends ChangeNotifier {
  bool isLoading = false;
  bool isChecked = false;
  bool isPasswordHidden = true;
  String userRole = 'USER';
  String name = '';

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Usermodel> userList = [];

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    String? agentId = prefs.getString('agentId');
    String? role = prefs.getString('role');

    return agentId != null &&
        agentId.isNotEmpty &&
        role != null &&
        role.isNotEmpty;
  }

  Future<bool> login() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      setLoading(true);
      final querySnapshot = await _firestore
          .collection('AGENT')
          .where('EMAIL', isEqualTo: emailController.text.trim().toLowerCase())
          .where('PASSWORD', isEqualTo: passwordController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userMap =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        await prefs.setString('agentId', querySnapshot.docs.first.id);
        await prefs.setString(
            'role', (userMap['ROLE'] ?? 'agent').toString().toUpperCase());
        print("Saved Role: ${prefs.getString('role')}");
        await prefs.setString('name', userMap['NAME'] ?? '');
        await prefs.setString('image', userMap['IMAGE'] ?? '');
        await prefs.setString('employeeid', userMap['EMPLOYEEID'] ?? '');

        if (isChecked) {
          await prefs.setBool('remember', true);
          await prefs.setString('email', userMap['EMAIL'] ?? '');
        } else {
          await prefs.remove('remember');
          await prefs.remove('email');
        }

        print("database user role ${userMap['ROLE']}");

        await fetchUsers();
        setLoading(false);
        return true;
      } else {
        setLoading(false);
        return false;
      }
    } catch (e) {
      print("Login Error: $e");
      setLoading(false);
      return false;
    }
  }

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();

    userRole = prefs.getString('role') ?? 'USER';
    name = prefs.getString('name') ?? '';

    print("user role is $userRole");
    notifyListeners();
  }

  Future<User?> signInWithGoogle() async {
    try {
      setLoading(true);
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("Google Sign-In cancelled");
        setLoading(false);
        return null;
      }
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) {
        setLoading(false);
        return null;
      }

      await _saveUserToFirestore(user);
      await fetchUsers();

      print("Google Login Success: ${user.email}");
      setLoading(false);
      return user;
    } catch (e) {
      print("Google Error: $e");
      setLoading(false);
      return null;
    }
  }

  Future<void> _saveUserToFirestore(User user) async {
    final docRef = _firestore.collection("USERS").doc(user.uid);

    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'email': user.email,
        'uid': user.uid,
        'createdAt': Timestamp.now(),
      });
      print("User saved");
    }
  }

  Future<void> fetchUsers() async {
    try {
      setLoading(true);
      final snapshot = await _firestore.collection("USERS").get();
      userList = snapshot.docs.map((doc) {
        return Usermodel.fromMap(doc.data(), doc.id);
      }).toList();

      print("Users fetched: ${userList.length}");
      setLoading(false);
    } catch (e) {
      print("Error fetching users: $e");
      setLoading(false);
    }
  }

  void toggleRemember() {
    isChecked = !isChecked;
    notifyListeners();
  }

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    bool remember = prefs.getBool('remember') ?? false;

    if (remember) {
      isChecked = true;
      emailController.text = prefs.getString('email') ?? '';
    }
    name = prefs.getString('name') ?? '';
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}