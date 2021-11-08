import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';

part 'name_state.dart';

class NameCubit extends Cubit<String> {
  List posts = [];
  String Uname = '';
  dynamic decodedMessage;
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
void Socketconnection() {
    channel.stream.listen((message) {
    final decodeMessage = jsonDecode(message);

    print(decodeMessage);

// print(serverTimeAsEpoch);
// channel.sink.close();
  });
  }
  login(Username,channel) {
  
 Uname = Username;
    emit(Username);
    channel.sink.add('{"type": "sign_in", "data": {"name": "$Username"}}');
//  channel.stream.listen((message) {
//     final decodeMessage = jsonDecode(message);

//     print(decodeMessage);

// // print(serverTimeAsEpoch);
// channel.sink.close();
//   });
}
NameCubit() : super('');
void getPosts() {
    channel.sink.add('{"type": "get_posts"}');
  }
void delete(Uid) {
    channel.sink.add('{"type": "delete_post", "data": {"postId": "$Uid"}}');
  }
   void Addpost(title, desc, url,channel) {
    channel.sink.add(
        '{"type": "create_post", "data": {"title": "$title", "description": "$desc", "image": "$url"}}');
        channel.stream.listen((message) {
    final decodeMessage = jsonDecode(message);

    print(decodeMessage);

// print(serverTimeAsEpoch);
// channel.sink.close();
  });
  }
   String getUname() {
    return state;
  }
}
