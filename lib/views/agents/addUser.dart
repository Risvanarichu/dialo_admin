import 'dart:typed_data';

import 'package:dialo_admin/providers/mainProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        title:  Text(context.watch<MainProvider>().isEdit
            ?"Edit User"
            :"Add User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
        
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
        
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
        
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Basic Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
        
                      const SizedBox(height: 20),
        
                      // Row(
                      //   children: [
                      //     Expanded(child: buildField("Full Name*")),
                      //
                      //     const SizedBox(width: 20),
                      //
                      //     Expanded(child: buildField("Email Address*")),
                      //   ],
                      // ),
                      //
                      // const SizedBox(height: 15),
                      //
                      // Row(
                      //   children: [
                      //     Expanded(child: buildField("Phone Number*")),
                      //
                      //     const SizedBox(width: 20),
                      //
                      //     Expanded(child: buildField("Employee ID*")),
                      //   ],
                      // ),
                      //
                      // const SizedBox(height: 15),
                      // SizedBox(width: 300, child: buildField("Role*")),
        
                      Row(
                        children: [
        
        
                          ///-------------NAME--------------------
        
        
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Full Name',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                          TextFormField(
                            controller: context.read<MainProvider>().nameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]'),
                              ),
                            ],
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintText: "Enter name",
                                hintStyle: TextStyle(color: Colors.grey),
                                // errorStyle: TextStyle(color: Colors.red),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
        
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,
                                      width: 2),
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Name";
                              }
                              if (value.length < 3) {
                                return 'Name must be at least 3 Character';
                              }
                              return null;
                            },
                          ),
                              ],
                            ),
                          ),
        
        
        
        
                          ///-----------------EMAIL-----------------------
        
        
                          const SizedBox(width: 20,),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Email',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                          TextFormField(
                            controller: context.read<MainProvider>().emailController,
        
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: "Enter Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                // errorStyle: TextStyle(color: Colors.red),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
        
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,
                                      width: 2),
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Email Address";
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return "Enter a valid Email";
                              }
                              return null;
                            },
                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
        
                      const SizedBox( height: 15,),
                      Row(
                        children: [
        
                          ///----------------------------PHONE---------------------
        
        
        
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Phone Number',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)
                            ],
                            controller: context.read<MainProvider>().phoneController,
        
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: "Enter Phone No.",
                                hintStyle: TextStyle(color: Colors.grey),
                                // errorStyle: TextStyle(color: Colors.red),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
        
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,
                                      width: 2),
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Phone No.";
                              }
                              if (value.length<10) {
                                return "Phone Number must be 10 digits";
                              }
                              return null;
                            },

                          ),
                              ],
                            ),
                          ),
        
        
                          ///------------EMPLOYEE ID--------------------
                          SizedBox(width: 20,),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Employee ID',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                          TextFormField(
                            controller: context.read<MainProvider>().employeeController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                            ],
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Enter ID",
                                hintStyle: TextStyle(color: Colors.grey),
                                // errorStyle: TextStyle(color: Colors.red),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
        
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,
                                      width: 2),
                                )
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the ID";
                              }
                              if (value.length < 3) {
                                return 'ID must be at least 3 Character';
                              }
                              return null;
                            },
                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
        
        
                      ///-----------------ROLE---------------------
        
        
                      const SizedBox(height: 15,),

                         Center(
                          child: Text(
                          'Role',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        ),
                      TextFormField(
                        controller: context.read<MainProvider>().roleController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "Enter Role",
                            hintStyle: TextStyle(color: Colors.grey),
                            // errorStyle: TextStyle(color: Colors.red),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),

                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,
                                  width: 2),
                            )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the role";
                          }
                          if (value.length < 3) {
                            return 'role must be at least 3 characters ';
                          }
                          return null;
                        },
                      ),





                      ///----------------PROFILE IMAGE--------------------



                      const SizedBox(height: 25),
        
                      const Text(
                        "Upload Profile Picture",
                        style: TextStyle(fontSize: 15),
                      ),
        
                      const SizedBox(height: 10),
        
                      Row(
                        children: [
                          Consumer<MainProvider>(
                            builder: (context,provider,child) {
                              return GestureDetector(
                                onTap: (){
                                  provider.pickImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE9E9ED),
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children:  [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: provider.imageBytes != null
                                        ?MemoryImage(provider.imageBytes!)
                                        :null,
                                        backgroundColor: Colors.blue,
                                        child:provider.imageBytes == null
                                    ?const Icon(
                                          Icons.person,
                                          size: 18,
                                          color: Colors.white)
                                          :null,
                                        ),

                                      SizedBox(width: 10),

                                      Text("Upload Photo"),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),

                          SizedBox(width: 60),

                          ///-------------------STATUS BUTTON--------------------

                          Consumer<MainProvider>(
                              builder: (context,provider,child){
                                if(!provider.isEdit) return const SizedBox();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5,),
                                    // const Text("Status",
                                    //   style: TextStyle(fontWeight: FontWeight.bold),
                                    // ),
                                    SizedBox(height: 15,),
                                    Row(
                                      children: [

                                        Text("Inactive",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        Switch(value: provider.isActive,
                                          onChanged: (value){
                                            provider.isActive = value;
                                            provider.notifyListeners();
                                          },
                                          overlayColor:  MaterialStateProperty.all(Colors.transparent),
                                          thumbColor: MaterialStateProperty.all(Colors.white),
                                          trackColor: MaterialStateProperty.resolveWith((states){
                                            return Colors.green;
                                          }),
                                          activeColor: Colors.white,
                                          activeTrackColor: Colors.green,

                                          inactiveThumbColor: Colors.white,
                                          inactiveTrackColor: Colors.green.shade200,
                                        ),
                                        Text("Active",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                          ),),
                                      ],
                                    )
                                  ],
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        
              const SizedBox(height: 30,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.themeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),

                    onPressed: () {},

                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:AppColors.greenColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
        
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final provider = context.read<MainProvider>();

                        if(!provider.isEdit && provider.imageBytes == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select image"),
                            )
                          );
                          return;
                        }

                        if(provider.isEdit){
                          await provider.updateUser();
                        }else{
                          await provider.addUser();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.isEdit
                              ?"User Updated Successfully"
                                  :"User Saved Successfully",

                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
        
                    // child:context.watch<MainProvider>().isLoading
                    // ?const CircularProgressIndicator(color: Colors.white,)
                    // :const
                    child: Text(
                      context.watch<MainProvider>().isEdit
                          ?"Update User":"Save & Invite",
                      style: TextStyle(color: AppColors.whitetext),),
                  ),
        

        

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
