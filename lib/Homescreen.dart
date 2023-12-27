import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dbminer/APIQuotes.dart';
import 'package:dbminer/Bookmark.dart';
import 'package:dbminer/CategoryQuoted.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Homescreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Homescreenstate();
  }
}

class Homescreenstate extends State<Homescreen> {
  late bool isConnected;
  List<String> CategoryAPI = [
    'age',
    'alone',
    'amazing',
    'anger',
    'architecture',
    'art',
    'attitude',
    'beauty',
    'best',
    'birthday',
    'business',
    'car',
    'change',
    'communications',
    'computers',
    'cool',
    'courage',
    'dad',
    'dating',
    'death',
    'design',
    'dreams',
    'education',
    'environmental',
    'equality',
    'experience',
    'failure',
    'faith',
    'family',
    'famous',
    'fear',
    'fitness',
    'food',
    'forgiveness',
    'freedom',
    'friendship',
    'funny',
    'future',
    'god',
    'good',
    'government',
    'graduation',
    'great',
    'happiness',
    'health',
    'history',
    'home',
    'hope',
    'humor',
    'imagination',
    'inspirational',
    'intelligence',
    'jealousy',
    'knowledge',
    'leadership',
    'learning',
    'legal',
    'life',
    'love',
    'marriage',
  ];
  List<String> categories1 = [
    'general',
    'life',
    'success',
    'motivational',
    'fun',
    'programming',
    'dream',
    'failure',
    'gaming',
    'birthday',
    'Humorous',
    'Travel'
  ];
  late var connectivityResult;
  void initializeTheme() async {
    bool? storedThemeMode = GetStorage().read("appTheme");
    if (storedThemeMode != null) {
      isDarkMode.value = storedThemeMode;
      updateThemeMode(isDarkMode.value);
    }
  }

  @override
  void initState() {
    super.initState();
    fun();
  }

  fun() async {
    connectivityResult = await Connectivity().checkConnectivity();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (connectivityResult != ConnectivityResult.none) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Catgeroy From API",
            style: TextStyle(),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  isDarkMode.value = !isDarkMode.value;
                  updateThemeMode(isDarkMode.value);
                  GetStorage().write("appTheme", isDarkMode.value);
                },
                icon: Icon(isDarkMode.value ? Icons.dark_mode : Icons.light)),
            IconButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Bookmark(),
                  ));
                },
                icon: Icon(Icons.favorite)),
          ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: CategoryAPI.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryQuotes(
                        category_name: CategoryAPI[index],
                      )));
                },
                title: Text(CategoryAPI[index]),
              ),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Category Json",
            style: TextStyle(),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  isDarkMode.value = !isDarkMode.value;
                  updateThemeMode(isDarkMode.value);
                  GetStorage().write("appTheme", isDarkMode.value);
                },
                icon: Icon(isDarkMode.value ? Icons.dark_mode : Icons.light)),
          ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: categories1.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CategoryJson(category: categories1[index]),
                  ));
                },
                title: Text(categories1[index]),
              ),
            );
          },
        ),
      );
    }
  }
}

void updateThemeMode(bool darkMode) {
  Get.changeThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
}

RxBool isDarkMode = false.obs;
