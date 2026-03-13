import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeadSettingsScreen extends StatefulWidget {
  LeadSettingsScreen({super.key});

  @override
  State<LeadSettingsScreen> createState() => _LeadSettingsScreenState();
}
class _LeadSettingsScreenState extends State<LeadSettingsScreen>{
  bool showAdditionalDetails = false;
  bool showCallStatus = false;

  List<String> callStatus = [];
  TextEditingController statusController = TextEditingController();
  List<Map<String, dynamic>> categories = [
    {
      "title": "Category 1",
      "sub": ["Sub Category 1.1", "Sub Category 1.2"],
      "expanded": false
    },
    {
      "title": "Category 2",
      "sub": ["Sub Category 2.1"],
      "expanded": false
    },
    {
      "title": "Category 3",
      "sub": ["Sub Category 3.1"],
      "expanded": false
    }
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Row(
        children: [

          Container(
            width: 1,
            color: Colors.grey.shade900,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      "lead settings",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: .100),
                    child: Text(
                      "Home/Settings/Leads Settings",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),

                  Expanded(
                    child: Center(
                      child: Container(
                        width: 1200,
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            _leftCard((){
                              setState(() {
                                showAdditionalDetails = true;
                                showCallStatus = false;
                              });
                            }),
                            if (showAdditionalDetails) _rightCard(),
                            if (showCallStatus) _callStatusCard(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

          )

        ],
      ),
    );

  }

  Widget _leftCard(VoidCallback onAddLeadTap){
    return Container(
      width: 400,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.black
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "Add leads",
            style: TextStyle(
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: onAddLeadTap,

            child: _roundBox("Additional Details"),
          ),
          SizedBox(height: 80,),

          Text(
            "Lead status",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              setState(() {
                showCallStatus = true;
                showAdditionalDetails = false;
              });
            },
            child: _roundBox("Call Status"),
          ),
        ],
      ),
    );
  }

  Widget _rightCard(){
    return Container(
      width: 350,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Additional Details",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 5,),

            ...List.generate(categories.length, (index){
              var category = categories[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState((){
                        categories[index]["expanded"] = !(categories[index]["expanded"]?? false);
                      });
                    },
                    child: _categoryRow(category["title"]),
                  ),
                  if (category["expanded"])
                    Column(
                      children: category["sub"].isEmpty
                          ?[Text("No Sub Category", style: TextStyle (fontSize: 12))]
                          : List.generate(category["sub"].length,
                            (subIndex) => _subCategoryRow(
                          category['sub'][subIndex],
                          index,
                        ),
                      ),
                    ),
                ],
              );

            }),


            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _addCategoryBox(),


                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                  ),
                  onPressed: (){},
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
  Widget _categoryRow(String title){
    return Padding(
      padding: EdgeInsets.only(bottom: 20, ),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 6),
            _submitBox(),

          ],
        ),
      ),
    );
  }

  Widget _submitBox(){
    return Container(
      height: 32,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(padding: EdgeInsets.only(right: 5),
          child: Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _subCategoryRow(String title,int categoryIndex){
    return Padding(
      padding: EdgeInsets.only(left: 150, bottom: 10),
      child : SizedBox(
        width: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 1),
            _plusBox(categoryIndex),
          ],
        ),
      ),
    );
  }

  Widget _plusBox(int categoryIndex){
    return Container(
      height: 32,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: (){
          setState(() {
            int subLength = categories[categoryIndex]['sub'].length + 1;

            categories[categoryIndex]['sub'].add(
                "Sub Category ${categoryIndex + 1}.$subLength"
            );
          });
        },

        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(Icons.add, size: 20,),
          ),
        ),
      ),
    );
  }

  Widget _roundBox(String text){
    return Container(
      width: 380,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Text(text),
    );
  }
  Widget _addCategoryBox() {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 0,
          side: BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: () {
          setState(() {
            categories.add({
              "title": "Category ${categories.length + 1}",
              "sub": ["Sub Category ${categories.length + 1}.1"],
              "expanded": true
            });
          });
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add New Category",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),

      ),
    );
  }
  Widget _callStatusCard(){
    return Container(
      width:  350,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Call Status",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 50,),


          Container(
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: statusController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    setState(() {
                      if(statusController.text.isNotEmpty){
                        callStatus.add(statusController.text);
                        statusController.clear();
                      }
                    });
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 40,),

          Text(
            "Status",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10,),

          ...callStatus.map((e) => Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child:  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                SizedBox(width: 10,),
                Text(e),
              ],
            ),
          )),
          Spacer(),
          //     ),
          // ),

          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Colors.black),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 12,
                ),
              ),
              onPressed: (){},
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),

    );
  }
}


