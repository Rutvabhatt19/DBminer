import 'package:flutter/material.dart';

class Bookmark extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Bookmarkstate();
  }
}

class Bookmarkstate extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Favrouites"),
        ),
        body: list.isEmpty
            ? Center(child: Text('No Favrioutes available'))
            : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "${list[index]}",
                  ),
                ),
              );
            }));
  }
}

List<String> list = [];
