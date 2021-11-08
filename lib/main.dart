import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project1/Home.dart';
import 'package:project1/cubit/name_cubit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: BlocProvider(
          create: (context) => NameCubit(),
          child: MyHomePage(title: 'Flutter Capitalize'),
        ));
  }
}

final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

TextEditingController username_Inpu = TextEditingController();
String username_Input = '';

class _MyHomePageState extends State<MyHomePage> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 110, left: 20.0, right: 20.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.people_alt,
                    size: 80.0,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'USERNAME',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    onChanged: (String? value) {
                      setState(() {
                        username_Input = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                      child: Text('LOGIN'),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 92, vertical: 10),
                          primary: Colors.green,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        if (username_Input.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Fill all the textfield",  textAlign: TextAlign.center,                            style: TextStyle(fontSize: 18),

 ),
                            duration: const Duration(seconds: 2),
                          ));
                        } else {
                          context
                              .read<NameCubit>()
                              .login(username_Input, channel);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Home(channel: channel)),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

login() {
  channel.sink.add('{"type":"sign_in","data":{"name":"$username_Input"}}');

  channel.stream.listen((message) {
    final decodeMessage = jsonDecode(message);

    print(decodeMessage);

// print(serverTimeAsEpoch);
// channel.sink.close();
  });
}
