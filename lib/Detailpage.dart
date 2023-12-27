import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:dbminer/Controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

class Detailspage extends StatefulWidget {
  String q;
  String a;
  String c;
  final String category;
  Detailspage({
    required this.category,
    required this.a,
    required this.q,
    required this.c,
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Detailspagestate(category, q, a, c);
  }
}

class Detailspagestate extends State<Detailspage> {
  late String category;
  late QuotesController categoryController;
  static GlobalKey key = GlobalKey();
  Detailspagestate(this.category, this.q, this.a, this.c) {
    categoryController = QuotesController(category);
  }
  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  String q;
  String a;
  String c;
  List<String> imglist = [
    'Assates/Images/img1.jpg',
    'Assates/Images/img2.jpg',
    'Assates/Images/img3.jpg',
    'Assates/Images/img4.jpg',
    'Assates/Images/img5.jpg',
    'Assates/Images/img6.jpg',
  ];
  List<String> fontlist = [
    'Caveat',
    'Lobster',
    'RubikDoodleShadow',
    'Satisfy',
    'Sevillana'
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$category',
        ),
        actions: [
          IconButton(
              onPressed: () {
                setWallpaper();
              },
              icon: Icon(Icons.image)),
        ],
      ),
      body: RepaintBoundary(
        key: key,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    q,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        fontFamily: Font()),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  trailing: Text(
                    " - $a",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        fontFamily: Font()),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Img()),
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }

  void setWallpaper() async {
    RenderRepaintBoundary boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    File tempFile =
    File('${(await getExternalStorageDirectory())!.path}/screenshot.png');
    await tempFile.writeAsBytes(pngBytes);

    await AsyncWallpaper.setWallpaperFromFile(
        filePath:
        '${(await getExternalStorageDirectory())!.path}/screenshot.png');
    print('Wallpaper set successfully');
  }

  String Img() {
    int min = 0;
    late final Random random;
    int max = imglist.length - 1;
    random = Random();
    int r = min + random.nextInt(max - min);
    String a = imglist[r].toString();
    return a;
  }

  String Font() {
    int min = 0;
    late final Random random;
    int max = fontlist.length - 1;
    random = Random();
    int r = min + random.nextInt(max - min);
    String a = fontlist[r].toString();
    print(a);
    return a;
  }
}
