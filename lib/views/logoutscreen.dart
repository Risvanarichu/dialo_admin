import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget{
  LogoutPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Row(
        children: [


          Container(
            width: 1,
            color: Colors.grey.shade900,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(25),
              child:SizedBox.expand(
                child: Container(
                  width: double.infinity,


                  decoration: BoxDecoration(
                    color: Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(4),
                  ),

                  child:Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'You Have Been Logged Out',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D4C73),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5,),
                        SizedBox(
                          width: 350,
                          child: Divider(
                            color: Colors.grey,

                          ),
                        ),
                        SizedBox(height: 20,),

                        Text(
                          "You have successfully logged out of the CRM. See you ",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Soon!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),

                        SizedBox(height: 80,),

                        SizedBox(
                          width: 240,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF6FBF5),
                              elevation: 6,
                              shadowColor: Colors.black54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            child: Text(
                              'Return back to home',
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}