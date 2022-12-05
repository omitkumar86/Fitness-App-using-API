import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homework_35/model_class.dart';
import 'package:homework_35/second_page.dart';
import 'package:homework_35/widget.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String link =
      "https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR2gsu4SRvRRFkHK8JPTWHZXmaNP0dtpOG6h7ep4zQp7WaamX5S1UaSrc3A";

  List<Exercise> allData = [];
  late Exercise exercise;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  bool isLoading = false;
  fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var responce = await http.get(Uri.parse(link));
      print("Status code is ${responce.statusCode}");
      if (responce.statusCode == 200) {
        var data = jsonDecode(responce.body);
        for (var i in data["exercises"]) {
          exercise = Exercise(
              id: i["id"],
              title: i["title"],
              thumbnail: i["thumbnail"],
              seconds: i["seconds"],
          gif: i["gif"]);

          setState(() {
            allData.add(exercise);
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("the problem is $e");
      showToast("Somthing was wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      progressIndicator: spinkit,
      child: Scaffold(
        backgroundColor: Color(0xff0A0C23).withOpacity(0.5),
        //backgroundColor: Colors.white38,
        appBar: AppBar(
          title: Text("Fitness App"),
          centerTitle: true,
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: allData.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset.fromDirection(2.0, 4.0),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xff0A0C23), width: 2),
                      image: DecorationImage(
                        image: NetworkImage("${allData[index].thumbnail}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 200,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      // begin: Alignment.bottomCenter,
                      // end: Alignment.topCenter,
                      // colors: [
                      // Colors.black,
                      // Colors.black54,
                      // Colors.transparent
                      // ]),
                        color: Colors.white.withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset.fromDirection(2.0, 4.0),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xff0A0C23), width: 0.5),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        "${allData[index].title}",
                        style: myStyle(18, Colors.white60, FontWeight.w600),
                      ),
                      height: 40,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 35,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SecondPage(
                              exercise: allData[index],
                            )));
                      },
                      child: Container(
                        alignment: Alignment.center,
                      height: 30,
                      width: 55,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff0A0C23), width: 1),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange,
                      ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Go" ,style: myStyle(18, Colors.black, FontWeight.w600),),
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black,),
                          ],
                        ),
                  ),
                    ),

                  ),
                ],
              );
            }),
      ),
    );
  }
}

myStyle(double fs, Color clr, [FontWeight? fw]) {
  return TextStyle(fontSize: fs, color: clr, fontWeight: fw);
}

showToast(String title) {
  return Fluttertoast.showToast(
      msg: "${title}",
      //toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER_LEFT,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0);
}
