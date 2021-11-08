import 'dart:convert';

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/About_us.dart';
import 'package:project1/Detail.dart';
import 'package:project1/Favourite.dart';
import 'package:project1/add_post.dart';
import 'package:project1/cubit/name_cubit.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  Home({required this.channel, Key? key}) : super(key: key);
  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return _Home(channel);
  }
}

class _Home extends State<Home> {
  _Home(this.channel);
  WebSocketChannel channel;

  dynamic decodedMessage;
  String textID = "";

  List _allpost = [];
  List posts = [];
  bool isFavorite = false;
  bool favouriteClicked = false;
  List favoritePosts = [];

  @override
  initState() {
    super.initState();
    widget.channel.stream.listen((results) {
      decodedMessage = jsonDecode(results);
      if (decodedMessage['type'] == 'all_posts') {
        posts = decodedMessage['data']['posts'];
        _allpost = posts;
      }
      setState(() {});
    });
    getPosts();
  }

  void getPosts() {
    widget.channel.sink.add('{"type": "get_posts"}');
  }

  sortDate() {
    for (int i = 0; i >= posts.length; i++) {}
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NameCubit(),
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  color: Colors.amberAccent,
                ),
                height: 120,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => About_us(),
                            ));
                      },
                      child: Text('About Our App')),
                  TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/');
                      },
                      child: Text('Log Out')),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text("ALL POSTS"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    print(favouriteClicked);
                    if (favouriteClicked == true) {
                      favouriteClicked = false;
                    } else {
                      favouriteClicked = true;
                    }
                  });
                },
                icon: Icon(Icons.favorite_sharp)),
          ],
          backgroundColor: Colors.lightBlue,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Add_post(channel: channel),
                ));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: (favouriteClicked == false)
            ? BlocBuilder<NameCubit, String>(
                builder: (context, index) {
                  print(posts.length);
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    title: posts[index]['title'],
                                    description: posts[index]['description'],
                                    url: posts[index]['image'],
                                  ),
                                ),
                              );
                              // Move to post details page
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Row(children: [
                                Image(
                                  image: NetworkImage(Uri.parse(
                                                  posts[index]['image'])
                                              .isAbsolute &&
                                          posts[index].containsKey('image')
                                      ? '${posts[index]['image']}'
                                      : 'https://www.freevector.com/uploads/vector/preview/31317/Revision_Freevector_Halloween-Festivity_Illustration_Mf0721.jpg'),
                                  height: 100,
                                  width: 100,
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${posts[index]["title"].toString().characters.take(20)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Created by ${posts[index]["author"].toString().characters.take(15)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Date Created: ${posts[index]["date"].toString().characters.take(10)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        children: [
                                          FavoriteButton(
                                              iconSize: 30.0,
                                              valueChanged: (isFavorite) {
                                                setState(() {
                                                  isFavorite = true;
                                                  if (favoritePosts
                                                      .contains(posts[index])) {
                                                    favoritePosts
                                                        .remove(posts[index]);
                                                    print('item already added');
                                                  } else {
                                                    favoritePosts
                                                        .add(posts[index]);
                                                  }
                                                  print(favoritePosts);
                                                });
                                              }),
                                          Ink(
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.delete_forever),
                                              color: Colors.black,
                                              onPressed: () {
                                                textID = posts[index]["_id"];
                                                print(textID);
                                                widget.channel.sink.add(
                                                    '{"type":"delete_post","data":{"postId": "$textID"}}');
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Ink(),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ),
                        );
                      });
                },
              )
            : BlocBuilder<NameCubit, String>(
                builder: (context, index) {
                  print(favoritePosts.length);
                  return ListView.builder(
                      itemCount: favoritePosts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    title: posts[index]['title'],
                                    description: posts[index]['description'],
                                    url: posts[index]['image'],
                                  ),
                                ),
                              );
                              // Move to post details page
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Row(children: [
                                Image(
                                  image: NetworkImage(Uri.parse(
                                                  posts[index]['image'])
                                              .isAbsolute &&
                                          posts[index].containsKey('image')
                                      ? '${posts[index]['image']}'
                                      : 'https://www.freevector.com/uploads/vector/preview/31317/Revision_Freevector_Halloween-Festivity_Illustration_Mf0721.jpg'),
                                  height: 100,
                                  width: 100,
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${posts[index]["title"].toString().characters.take(20)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Created by ${posts[index]["author"].toString().characters.take(15)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Date Created: ${posts[index]["date"].toString().characters.take(10)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        children: [
                                          FavoriteButton(
                                              iconSize: 30.0,
                                              valueChanged: (isFavorite) {
                                                setState(() {
                                                  isFavorite = true;
                                                  if (favoritePosts
                                                      .contains(posts[index])) {
                                                    favoritePosts
                                                        .remove(posts[index]);
                                                    print('item already added');
                                                  } else {
                                                    favoritePosts
                                                        .add(posts[index]);
                                                  }
                                                  print(favoritePosts);
                                                });
                                              }),
                                          Ink(
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.delete_forever),
                                              color: Colors.black,
                                              onPressed: () {
                                                textID = posts[index]["_id"];
                                                print(textID);
                                                widget.channel.sink.add(
                                                    '{"type":"delete_post","data":{"postId": "$textID"}}');
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Ink(),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ),
                        );
                      });
                },
              ),
      ),
    );
  }
}
