
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
  String? editingId;
  bool isEdit = false;
  bool isActive = true;
  FirebaseFirestore fbd = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final employeeController = TextEditingController();


  ///----------------PICK IMAGE---------------------

  Uint8List? imageBytes;
  String? imageName;
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
    
    
    Future<String?> uploadImage() async{
    if(imageBytes == null) return null;
    
    var uri = Uri.parse("https://api.cloudinary.com/v1_1/djk5svibf/image/upload",);
    var request = http.MultipartRequest("POST",uri);
    request.fields['upload_preset'] = "user_image";
    request.files.add(
      await http.MultipartFile.fromBytes("file",imageBytes!,filename: imageName,
      )
    );
    var response = await request.send();
    if(response.statusCode == 200){
      var res = await http.Response.fromStream(response);
      var data = jsonDecode(res.body);

      return data["secure_url"];
    }else{
      print("Upload Failed");
      return null;
    }
    }


    ///-----------------ADD USER-----------------


  Future<void> addUser() async {
    try {
      String now = DateTime
          .now()
          .microsecondsSinceEpoch
          .toString();

      String? imageUrl = await uploadImage();

    
      final user = {
        "NAME": nameController.text.trim(),
        "PHONE": phoneController.text.trim(),
        "EMAIL": emailController.text.trim(),
        "EMPLOYEEID": employeeController.text.trim(),
        "ROLE": roleController.text.trim(),
        "IMAGE":imageUrl,
      };
      await fbd.collection('AGENT').doc(now).set(user);
      await fetchUser();
      clearFields();
      imageBytes = null;
      notifyListeners();
    }catch(e){
      print("Error:$e");
    }
  }


  ///-----------------EDIT DATA---------------------


  void editData(Map<String,dynamic>user){
    nameController.text = user["NAME"]??"";
    phoneController.text = user["PHONE"]??"";
    emailController.text = user["EMAIL"]??"";
    employeeController.text = user["EMPLOYEEID"]??"";
    roleController.text = user["ROLE"]??"";
    
    editingId = user["ID"];
    isEdit = true;
    isActive = user["STATUS"]?? true;
    notifyListeners();
  }
  
  
  ///-------------UPDATE USER------------------

  Future<void>updateUser() async{
    try{
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
      imageBytes = null;
      isEdit = false;
    }catch(e){
      print("Update Error: $e");
    }
  }
  
  /// -------------FETCH DATA------------------


  List<Map<String,dynamic>> userList = [];
  Future<void>fetchUser() async{
    try{
      final snapshot = await fbd.collection('AGENT').get();
      userList = snapshot.docs.map((doc){
        return{
          "ID":doc.id,
          ...doc.data(),
        };
      }).toList();
      notifyListeners();
    }catch(e){
      print("Fetch Error : $e");
    }
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
  }
}