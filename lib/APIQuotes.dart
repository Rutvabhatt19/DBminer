import 'dart:convert';

import 'package:dbminer/Bookmark.dart';
import 'package:dbminer/Controller.dart';
import 'package:dbminer/Detailpage.dart';
import 'package:dbminer/Homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CategoryQuotes extends StatefulWidget {
  String category_name = '';
  CategoryQuotes({required this.category_name});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryQuotesstate(category_name);
  }
}

class CategoryQuotesstate extends State<CategoryQuotes> {
  String category_name = '';

  CategoryQuotesstate(this.category_name);

  List<Modalclass> quotelistformapi = [];
  late Database database;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openDatabaseAndFetchData();
  }

  Future<void> openDatabaseAndFetchData() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'quotes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE quotes(id INTEGER PRIMARY KEY AUTOINCREMENT, quote TEXT, author TEXT)',
        );
      },
      version: 1,
    );
    await fetchDataFromAPI();
  }

  Future<void> deleteAllData() async {
    try {
      await database.delete('quotes');
      print('All data deleted successfully.');
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  Future<void> fetchDataFromAPI() async {
    var apiKey = '9PeOWi/rY86tzaUgTTepqA==tUKwHrndNJ06hxsF';

    try {
      for (int i = 0; i < 10; i++) {
        var response = await http.get(
          Uri.parse(
              'https://api.api-ninjas.com/v1/quotes?category=$category_name'),
          headers: {'X-API-KEY': apiKey},
        );

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body) as List<dynamic>;

          for (var item in jsonData) {
            Modalclass modelClass = Modalclass.fromJson(item);
            quotelistformapi.add(modelClass);
            await database.insert('quotes', {
              'quote': modelClass.quote,
              'author': modelClass.author,
            });
          }
        } else {
          print('Request failed with status: ${response.statusCode}.');
          print('Response body: ${response.body}');
        }
      }

      setState(() {});
    } catch (error) {
      print('Error: $error');
    }
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Quotes From API",
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
          itemCount: quotelistformapi.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Detailspage(
                      a: quotelistformapi[index].author,
                      q: quotelistformapi[index].quote,
                      c: category_name,
                      category: category_name,
                    ),
                  ));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100,
                          width: 280,
                          child: Text(quotelistformapi[index].quote)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          list.add(quotelistformapi[index].quote);
                          fun();
                        },
                        icon: Icon(Icons.favorite_border),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

void fun() {
  Fluttertoast.showToast(
      msg: "Bookmark Added",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
