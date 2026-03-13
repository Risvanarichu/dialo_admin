import 'package:flutter/material.dart';

class Adduser extends StatefulWidget {
  const Adduser({super.key});

  @override
  State<Adduser> createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formKey,
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
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(),
                        ),
                         validator: (value){
                          if(value == null || value.isEmpty){
                            return "Enter the Name";
                          }
                          if(value.length <3){
                            return "Name must be at least 3 characters";
                          }
                          return null;
                         },
                      ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder()
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Enter Email Address";
                          }
                          if(value.length==10){
                            return "Phone number must be 10 digits";
                          }return null;
                          },
                      ),
                      ),
                      const SizedBox(height: 16,),
                      Row(
                        children: [
                          Expanded(child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Phone Number",
                                border: OutlineInputBorder()
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter phone number";
                              }
                              if(value.length==10){
                                return "Phone number must be 10 digits";
                              }return null;
                            },
                          ),
                          ),
                          
                          SizedBox(width: 20,),
                          Expanded(child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Employee ID",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value){
                              if(value == null|| value.isEmpty){
                                return "Enter Employee ID";
                              }
                              if(value.length<3){
                                return "Employee ID at least 3 characters";
                              }
                              return null;
                            },
                          ))
                        ],
                      ),
                      const SizedBox(height: 16,),
                      Expanded(child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Role",
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "enter the role";
                          }
                          return null;
                        },

                      ),
                      ),
                      
                      const SizedBox(height: 25,),
                      const Text(
                          "Upload Profile Picture",
                      style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10,),
                            Text("Upload Photo"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,vertical: 15,),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                          onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("User Saved Successfully"))
                                  );
                                }
                          },
                          child: const Text("Save & Invite"),
                          ),
                          const SizedBox(width: 20,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,vertical: 15
                              ),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: (){},
                            child: const Text("Save As Draft"),
                          )
                        ],
                      )
                    ],
                  )
                ],
          )),
        ),
      ),),
    );
  }
}
