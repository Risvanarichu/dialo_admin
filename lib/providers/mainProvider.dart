
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainProvider extends ChangeNotifier {
  MainProvider(){
    fetchUser();
  }
  bool isButtonLoading = false;
  bool isLoading = false;
  bool isPageLoading = false;
  String? editingId;
  bool isEdit = false;
  bool isActive = true;
  FirebaseFirestore fbd = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final employeeController = TextEditingController();
  final searchController = TextEditingController();
  List<Map<String,dynamic>>filteredUserList = [];
  List<Map<String,dynamic>> userList = [];

  String selectedRole = "All";
  String selectedStatus = "All";


  ///----------------PICK IMAGE---------------------

  Uint8List? imageBytes;
  String? imageName;
  String? existingImage;

  void setLoading(bool value){
    isLoading = value;
    notifyListeners();
  }


  Future<void> pickImage() async{
    final picker =  ImagePicker();
    final picked= await picker.pickImage(source: ImageSource.gallery);
    if(picked != null) {
      imageBytes = await picked.readAsBytes();
      imageName = picked.name;
      notifyListeners();
    }
    }

    ///------------------UPLOAD IMAGE---------------------


  Future<String?> uploadImage() async {
    if (imageBytes == null) {
      print(" No image selected");
      return null;
    }

    try {
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/djk5svibf/image/upload");

      var request = http.MultipartRequest("POST", uri);
      request.fields['upload_preset'] = "user_images";

      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          imageBytes!,
          filename: imageName ?? "image.jpg",
        ),
      );

      var response = await request.send();
      var res = await http.Response.fromStream(response);

      print("STATUS CODE: ${response.statusCode}");
      print(" RESPONSE BODY: ${res.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(res.body);
        return data["secure_url"];
      } else {
        return null;
      }
    } catch (e) {
      print(" Upload Error: $e");
      return null;
    }
  }


    ///-----------------ADD USER-----------------


  Future<void> addUser() async {
    if(isLoading) return;
    try {

      setLoading(true);
      String? imageUrl = await uploadImage();
      // if(imageUrl == null || imageUrl.isEmpty){
      //   print("Image upload failed");
      //   return;
      // }
      String now = DateTime
          .now()
          .microsecondsSinceEpoch
          .toString();

      print("IMAGE URL : $imageUrl");

    
      final user = {
        "NAME": nameController.text.trim(),
        "PHONE": phoneController.text.trim(),
        "EMAIL": emailController.text.trim(),
        "EMPLOYEEID": employeeController.text.trim(),
        "ROLE": roleController.text.trim(),
        "IMAGE":imageUrl ??"",
        "STATUS":true,
      };

      if(await isUserExists(emailController.text.trim())){
        print("User already exists");
        isLoading = false;
        notifyListeners();
        return;
      }
      await fbd.collection('AGENT').doc(now).set(user);
      await fetchUser();
      clearFields();
      // imageBytes = null;
      notifyListeners();
    }catch(e){
      print("Error:$e");
    }finally{
      setLoading(false);
    }
  }


  Future<bool>isUserExists(String email)async{
    final result = await fbd.collection("AGENT").where("EMAIL",isEqualTo: email).get();
    return result.docs.isNotEmpty;
  }

  ///-----------------EDIT DATA---------------------


  void editData(Map<String,dynamic>user){
    nameController.text = user["NAME"]??"";
    phoneController.text = user["PHONE"]??"";
    emailController.text = user["EMAIL"]??"";
    employeeController.text = user["EMPLOYEEID"]??"";
    roleController.text = user["ROLE"]??"";

    existingImage = user["IMAGE"];
    
    editingId = user["ID"];
    isEdit = true;
    isActive = user["STATUS"]?? true;
    notifyListeners();
  }
  
  
  ///-------------UPDATE USER------------------


  Future<void>updateUser() async{
    try{
      setLoading(true);
      if(editingId == null) return;
      // {
      //   print("Edit ID is null");
      //   return;
      // }
      String? imageUrl;
      
      if(imageBytes != null){
        imageUrl = await uploadImage();
      }
      final updateUser = {
        "NAME" : nameController.text.trim(),
        "PHONE":phoneController.text.trim(),
        "EMAIL":emailController.text.trim(),
        "EMPLOYEEID":employeeController.text.trim(),
        "ROLE":roleController.text.trim(),
        "STATUS":isActive,
      };
      
      if(imageUrl != null){
        updateUser["IMAGE"] = imageUrl;
      }
      
      await fbd.collection('AGENT').doc(editingId).update(updateUser);
      await fetchUser();
      clearFields();
      // imageBytes = null;
      // isEdit = false;
      clearFields();
    }catch(e){
      print("Update Error: $e");
    }finally{
      setLoading(false);
    }
  }
  
  /// -------------FETCH DATA------------------



  Future<void>fetchUser() async{
    try{
      setPageLoading(true);
      final snapshot = await fbd.collection('AGENT').get();
      // print("Total docs: ${snapshot.docs.length}");
      userList = snapshot.docs.map((doc){
        print("User Data:${doc.data()}");
        return{
          "ID":doc.id,
          ...doc.data(),
        };
      }).toList();

      filteredUserList = List.from(userList);
      applyFilter();
      notifyListeners();
    }catch(e){
      print("Fetch Error : $e");
    }finally{
      setPageLoading(false);
    }
  }


  ///---------------SEARCH FUNCTION-----------



  void searchUser(String value) {
    final search = value.toLowerCase();

    if(search.isEmpty){
      filteredUserList = List.from(userList);
    }else{
      filteredUserList = userList.where((user){
        final name = user["NAME"].toString().toLowerCase();
        final role = user["ROLE"].toString().toLowerCase();
        final email = user["EMAIL"].toString().toLowerCase();
        final status = user["STATUS"] == true ? "active":"inactive";

        return name.contains(search)||
        role.contains(search)||
        email.contains(search)||
        status.contains(search);
      }).toList();
    }
   notifyListeners();
  }

  void applyFilter({String searchText = ""}) {
    filteredUserList = userList.where((user) {
      /// SEARCH
      final nameMatch = user["NAME"].toString().toLowerCase().contains(searchText.toLowerCase());

      /// ROLE FILTER
      final roleMatch = selectedRole == "All" ||
          user["ROLE"] == selectedRole;

      /// STATUS FILTER
      final statusMatch = selectedStatus == "All" ||
          (selectedStatus == "Active" && user["STATUS"] == true) ||
          (selectedStatus == "Inactive" && user["STATUS"] == false);

      return nameMatch && roleMatch && statusMatch;
    }).toList();

    notifyListeners();
  }

  void setPageLoading(bool value){
     isPageLoading = value;
    notifyListeners();
  }

  void setButtonLoading(bool value){
    isButtonLoading = value;
    notifyListeners();
  }

  ///---------------DELETE USER---------------

  Future<void> deleteUser(String id) async{
    try{
      await fbd.collection('AGENT').doc(id).delete();
      await fetchUser();
    }catch(e){
      print("Delete Error:$e");
    }
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    employeeController.clear();
    roleController.clear();

    editingId = null;
    isEdit = false;
    isActive = true;
    imageBytes = null;
    existingImage = null;
  }
}