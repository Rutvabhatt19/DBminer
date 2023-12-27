import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CategoryController extends GetxController {
  List<String> categories = [];

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
    await DataBaseHelper().initializeDatabase();
    List<Map<String, dynamic>> categoryList =
    await DataBaseHelper().queryAllCategory();
    categories =
        categoryList.map((category) => category['category'] as String).toList();
    update();
  }
}


class QuotesController extends GetxController {
  final String category;
  List<Map<String, dynamic>> quotes = [];
  QuotesController(this.category);

  @override
  void onInit() {
    super.onInit();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    await DataBaseHelper().initializeDatabase();
    List<Map<String, dynamic>> quotesList =
    await DataBaseHelper().getQuotesByCategory(category);

    print("Quotes List: $quotesList");
    if (quotesList != null) {
      quotes = quotesList;
    }
    update();
  }
}
class Modalclass {
  final String quote;
  final String author;
  final String category;

  Modalclass(
      {required this.quote, required this.author, required this.category});

  factory Modalclass.fromJson(Map<String, dynamic> json) {
    return Modalclass(
        quote: json['quote'],
        author: json['author'],
        category: json['category']);
  }
  static List<Modalclass> parseList(List<dynamic> jsonList) {
    return jsonList.map((json) => Modalclass.fromJson(json)).toList();
  }

  Map<String, Object?> toMap() {
    return {
      'quote': quote,
      'author': author,
      'category': category,
    };
  }
}

class DataBaseHelper {
  static final DataBaseHelper _instance = DataBaseHelper._internal();
  late Database _database;
  String TableName = 'quotes';

  factory DataBaseHelper() => _instance;

  DataBaseHelper._internal();

  Future<void> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'quotes.db');

    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TableName (
        id INTEGER PRIMARY KEY,
        category TEXT NOT NULL,
        quote TEXT  NOT NULL,
        author TEXT  NOT NULL
      )
    ''');

    String jsonString = await rootBundle.loadString('Assates/category.json');
    Map<String, dynamic> data = json.decode(jsonString);

    data.forEach((category, quotes) {
      if (quotes is List) {
        quotes.forEach((quote) async {
          if (quote['quote'] != null) {
            await db.insert('quotes', {
              'category': category,
              'quote': quote['quote'],
              'author': quote['author']
            });
          }
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCategory() async {
    return await _database.query(TableName);
  }

  Future<List<Map<String, dynamic>>> getQuotesByCategory(
      String category) async {
    try {
      if (_database == null || !_database.isOpen) {
        return [];
      }

      return await _database
          .query('quotes', where: 'category = ?', whereArgs: [category]);
    } catch (e) {
      print('Error in getQuotesByCategory: $e');
      return [];
    }
  }
}

