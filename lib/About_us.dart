import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class About_us extends StatefulWidget {
  @override
  _About_us createState() => _About_us();
}

class _About_us extends State<About_us> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        
          centerTitle: true,
          title: Text(
            "ABOUT US",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.lightBlue,
          actionsIconTheme:
              IconThemeData(size: 30.0, color: Colors.black, opacity: 10.0),
        ),
        //

        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "ABOUT US",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Times New Roman",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),

                          Text(
"The project has been developed by student VIMALAN A/L Rajakumar who learned to developed this application with minimal experience in the mobile development field but the developers of the system have approximately four years of learning in the software development field which helped the developer to develop this application successfully even without any prior knowledge on mobile application development. The organization's goal is to help people to track their posts. ",                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Times New Roman",
                            ),
                          ),
                          SizedBox(height: 10.0),

                          //
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
