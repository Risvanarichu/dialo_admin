import 'dart:typed_data';

import 'package:dialo_admin/providers/agentProvider.dart';
import 'package:dialo_admin/views/agents/web_users.dart';
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
  late final provider = context.read<MainProvider>();


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

      body: Stack(
        children: [
          SingleChildScrollView(
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
                                  crossAxisAlignment:CrossAxisAlignment.start,
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
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),

                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red,width: 2)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red,
                                          width: 1),
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
                                  crossAxisAlignment:CrossAxisAlignment.start,
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
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),

                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red,width: 2)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red,
                                          width: 1),
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
                                  crossAxisAlignment:CrossAxisAlignment.start,
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
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),

                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red,width: 2)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red,
                                          width: 1),
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
                                  crossAxisAlignment:CrossAxisAlignment.start,
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
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),

                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red,width: 2)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red,
                                          width: 1),
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

                             Text(
                             'Role',
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               color: Colors.black,
                               fontWeight: FontWeight.bold,
                               fontSize: 14,
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
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),

                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red,width: 2)
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red,
                                      width: 1 ),
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


                          Column(
                            children: [

                              /// -------- Upload Center --------
                              Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Upload Profile Picture",
                                      style: TextStyle(fontSize: 15),
                                    ),

                                    const SizedBox(height: 10),

                                    Consumer<MainProvider>(
                                      builder: (context, provider, child) {
                                        return GestureDetector(
                                          onTap: () {
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
                                              children: [
                                                CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: provider.imageBytes != null
                                                      ? MemoryImage(provider.imageBytes!)
                                                      :(provider.existingImage != null &&
                                                  provider.existingImage!.isNotEmpty)
                                                  ?NetworkImage(provider.existingImage!)
                                                  :null,
                                                  backgroundColor:AppColors.themeColor,
                                                  child: provider.imageBytes == null&&
                                                      (provider.existingImage == null ||
                                                      provider.existingImage!.isEmpty)
                                                      ? const Icon(Icons.person, color: Colors.white)
                                                      : null,
                                                ),
                                                const SizedBox(width: 10),
                                                const Text("Upload Photo"),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// -------- Status Right --------
                              Align(
                                alignment: Alignment.centerRight,
                                child: Consumer<MainProvider>(
                                  builder: (context, provider, child) {
                                    if (!provider.isEdit) return const SizedBox();

                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text("Inactive", style: TextStyle(fontWeight: FontWeight.bold)),

                                        const SizedBox(width: 8),

                                        GestureDetector(
                                          onTap: () {
                                            provider.isActive = !provider.isActive;
                                            provider.notifyListeners();
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            width: 55,
                                            height: 28,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: provider.isActive ? Colors.green : Colors.grey,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Align(
                                              alignment: provider.isActive
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: Container(
                                                width: 22,
                                                height: 22,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        const Text("Active", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )


                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      const SizedBox(width: 20),

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
                            onPressed:context.watch<MainProvider>().isLoading
                                ? null
                            :()async {
                              if (_formKey.currentState!.validate()) {
                                final provider = context.read<MainProvider>();
                                bool isUpdating = provider.isEdit;

                                if (!provider.isEdit && provider.imageBytes == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please select image")),
                                  );
                                  return;
                                }

                                if (isUpdating) {
                                  await provider.updateUser();
                                } else {
                                  await provider.addUser();
                                }

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                     isUpdating
                                          ? "User Updated Successfully"
                                          : "User Saved Successfully",
                                    ),
                                  ),
                                );
                              }
                            },


                            child:provider.isButtonLoading
                              ?const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: AppColors.whitetext,strokeWidth: 2,),
                            )
                                :Text(
                              context.watch<MainProvider>().isEdit
                                  ? "Update User"
                                  : "Save & Invite",
                              style: TextStyle(color: AppColors.whitetext),
                            ),
                          ),
                        ],
                      )





                    ],
                  ),
                ],
              ),
            ),
          ),
          Consumer<MainProvider>(
              builder: (context,provider,child){
                if(!provider.isLoading)return const SizedBox();
                return fullScreenLoader();
          })
        ],
      ),
    );
  }
}
