
import 'dart:typed_data';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MainProvider extends ChangeNotifier {
  FirebaseFirestore fbd = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final employeeController = TextEditingController();

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
      clearFields();
      imageBytes = null;
      notifyListeners();
    }catch(e){
      print("Error:$e");
    }
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    employeeController.clear();
    roleController.clear();
  }
}