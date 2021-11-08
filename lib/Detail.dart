// ignore_for_file: file_names, prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key? key,
    required this.title,
    required this.description,
    required this.url,
  }) : super(key: key);

  final String title;
  final String description;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POST DETAILS'),centerTitle: true,),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 40, right: 40, bottom: 10),
                child: Image(
                  image: NetworkImage(Uri.parse(url).isAbsolute
                      ? url
                      : 'https://www.freevector.com/uploads/vector/preview/31317/Revision_Freevector_Halloween-Festivity_Illustration_Mf0721.jpg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Flexible(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}