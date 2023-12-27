


import 'package:dbminer/APIQuotes.dart';
import 'package:dbminer/Bookmark.dart';
import 'package:dbminer/Controller.dart';
import 'package:dbminer/Detailpage.dart';
import 'package:dbminer/Homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CategoryJson extends StatefulWidget {
  final String category;
  CategoryJson({required this.category});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryJsonState(category);
  }
}

class CategoryJsonState extends State<CategoryJson> {
  late String category;
  late QuotesController categoryController;

  CategoryJsonState(this.category) {
    categoryController = QuotesController(category);
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes - $category'),
        centerTitle: true,
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
      body: FutureBuilder(
        future: categoryController.loadQuotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return GetBuilder<QuotesController>(
              init: categoryController,
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.quotes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Detailspage(
                              a: controller.quotes[index]['author'] ?? '',
                              q: controller.quotes[index]['quote'] ?? '',
                              c: category,
                              category: category),
                        ));
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(controller.quotes[index]['quote'] ?? ''),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            list.add(controller.quotes[index]['quote']);
                            fun();
                          },
                          icon: Icon(Icons.favorite_border),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
