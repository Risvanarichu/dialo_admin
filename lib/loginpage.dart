import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
  bool isChecked = false;
  bool isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();




  @override
  void initState (){
    super.initState();
    _loadUserData();

  }
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    bool remember = prefs.getBool('remember')?? false;

    if(remember){
      setState(() {
        isChecked = true;
        emailController.text = prefs.getString('email') ??'';
        passwordController.text = prefs.getString("password") ?? '';
      });
    }
  }
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(

                  image: AssetImage(
                    'assets/shibi.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),


          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 800,
                  height: 390,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )
                          ],
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                              key:_formKey,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _inputField(
                                      label: "Email/Username",
                                      hint: "Enter your Email",
                                      icon: Icons.email_outlined,
                                      controller: emailController,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return "Email is required";
                                        }
                                        final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                        );
                                        if (!emailRegex.hasMatch(
                                            value)) {
                                          return "Enter a your email address";
                                        }
                                        return null;
                                      },
                                      labelSize: 18,
                                      labelWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 25,),

                                    _inputField(
                                      label: "Password",
                                      hint: "Enter your Password",
                                      icon: Icons.lock_outline_rounded,
                                      isPassword: isPasswordHidden,
                                      controller: passwordController,
                                      validator: (value){
                                        if(value == null|| value.isEmpty){
                                          return "Password is required";
                                        }
                                        if(value.length<6){
                                          return"Password must be at least 6 characters";
                                        }
                                        if(!RegExp(r'[8-9]').hasMatch(value)){
                                          return 'Password must contain atleast one number';
                                        }
                                        return null;
                                      },
                                      labelSize: 18,
                                      labelWeight: FontWeight.bold,
                                      suffixIcon: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            isPasswordHidden = !isPasswordHidden;
                                          });
                                        },
                                        child: Icon(
                                          isPasswordHidden
                                              ?Icons.visibility_off
                                              :Icons.visibility,
                                          color: Colors.indigo[900],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8,),

                                    Row(
                                      children: [

                                        SizedBox(width: 8,),
                                        Text(
                                          "Remember me",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        GestureDetector(
                                          onTap: (){
                                            setState((){
                                              isChecked = !isChecked;
                                            });
                                          },
                                          child: Icon(
                                            isChecked

                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank_outlined,
                                            color: Colors.indigo[900],
                                          ),
                                        ),


                                      ],
                                    ),

                                    SizedBox(height: 28,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 140,
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue[900],
                                                padding: EdgeInsets.symmetric(vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                side: BorderSide(color: Colors.white),
                                              ),
                                              onPressed: () async {
                                                if(_formKey.currentState!.validate()){
                                                  final prefs = await SharedPreferences.getInstance();

                                                  if (isChecked){
                                                    await prefs.setString("email", emailController.text);
                                                    await prefs.setBool('remember', true);
                                                  }else {
                                                    await prefs.remove('email');
                                                    await prefs.remove('remember');
                                                  }
                                                  print("Login success");
                                                }
                                              },
                                              child: Text(
                                                "Log In",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.white
                                                ),
                                              ),
                                            )
                                        ),
                                        SizedBox(width: 17,),

                                        SizedBox(
                                          height: 40,
                                          child: ElevatedButton.icon(
                                              onPressed: (){},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue[900],
                                                padding: EdgeInsets.all(10),
                                                shape:  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                side: BorderSide(color: Colors.white),
                                              ),
                                              icon: Image.asset(
                                                "assets/google.png",
                                                height: 20,
                                              ),

                                              label:   Text(
                                                "Login with Google",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              )
                                          ),
                                        ),

                                      ],
                                    ),
                                  ]
                              )
                          ),
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget _inputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    double labelSize = 14,
    FontWeight labelWeight = FontWeight.bold,
    Widget? suffixIcon,
    TextEditingController? controller,
    String? Function(String?)?  validator,

  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: labelSize,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(height: 5,),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.indigo[900],

            ),
            suffixIcon: suffixIcon,
            hintText: hint,
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],

    );
  }
}
