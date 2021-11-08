import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/cubit/name_cubit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@override
class CreatePostPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => NameCubit(),
    ));
  }
}

class Add_post extends StatefulWidget {
  Add_post({required this.channel, Key? key}) : super(key: key);
  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return _Add_post(channel);
  }
}

TextEditingController title_Input = TextEditingController();
TextEditingController desc_Input = TextEditingController();
TextEditingController URL_Input = TextEditingController();

class _Add_post extends State<Add_post> {
  GlobalKey<FormState> validkey = GlobalKey<FormState>();

  _Add_post(this.channel);
  WebSocketChannel channel;
  String title = '';
  String description = '';
  String url = '';
  void checkConnect() async {
    channel.stream.listen((event) {
      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("ADD POST"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Card(
              child: Form(
                key: validkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    ////////////TITLE
                    ///
                    ///

                    TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Title:",
                        ),
                        onChanged: (String? value) {
                          setState(
                            () {
                              title = value!;
                            },
                          );
                        },
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "TITLE Column is Required"),
                        ])),
                    ////////// description
                    SizedBox(height: 20.0),

                    TextFormField(
                      controller: desc_Input,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Description:",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          description = value!;
                        });
                      },
                      minLines: null,
                      maxLines: 5,
                    ),
                    SizedBox(height: 20.0),

                    ////////URL
                    TextFormField(
                      controller: URL_Input,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Image url:",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          url = value!;
                        });
                      },
                      minLines: null,
                      maxLines: 2,
                    ),

                    SizedBox(height: 20.0),

                    ElevatedButton(
                        child: Text('SUBMIT'),
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
                          // context
                          //                           .read<NameCubit>()
                          //                           .Addpost(title, description, url, channel);
                          if (title.isNotEmpty &&
                              description.isNotEmpty &&
                              url.isNotEmpty) {
                            channel.sink.add(
                                '{"type": "create_post","data": {"title": "$title", "description": "$description", "image": "$url"}}');
                          
                              // Move to post details page
                            
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Data have been created",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              duration: const Duration(seconds: 2),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Fill all the textfield",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              duration: const Duration(seconds: 2),
                            ));
//                           channel.stream.listen((message) {
//                             final decodeMessage = jsonDecode(message);

//                             print(decodeMessage);

// // // print(serverTimeAsEpoch);
// channel.sink.close();

                            // });

                          }
                        }),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

// Create() {
//   final channel =
//       IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
//   channel.sink.add('{"type":"sign_in","data":{"name":"V"}}');

//   channel.sink.add(
//       '{"type": "create_post","data": {"title": "VJ", "description": "V", "image": "V"}}');
// channel.sink.add('{"type":"get_posts"}');
//   channel.stream.listen((message) {
//     final decodeMessage = jsonDecode(message);

//     print(decodeMessage);

// // print(serverTimeAsEpoch);
// // channel.sink.close();
//   });
// }

// login() {
//   final channel =
//       IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
//   channel.sink.add('{"type":"get_posts"}');

//   channel.stream.listen((message) {
//     final decodeMessage = jsonDecode(message);

//     print(decodeMessage);

// // print(serverTimeAsEpoch);
// // channel.sink.close();
//   });
// }
