import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Channel {
  final String? id;
  final Color color;
  final String imgPath;
  final String title;
  final String url;
  final String category;

  Channel(
      {this.id,
      required this.color,
      required this.imgPath,
      required this.title,
      required this.url,
      required this.category});

  int? colorToInt() {
    // ignore: deprecated_member_use
    return color.value;
  }

  static Color intToColor(int value) {
    return Color(value);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgPath': imgPath,
      'title': title,
      'url': url,
      'color': colorToInt(),
      'category': category
    };
  }

  static Channel fromMap(Map<String, dynamic> map) {
    return Channel(
        id: map['id'],
        imgPath: map['imgPath'],
        title: map['title'],
        url: map['url'],
        color: intToColor(map['color']),
        category: map['category']);
  }

  @override
  String toString() {
    return "Channel{id: $id, color: $color, imgPath: $imgPath, title: $title, url: $url, category: $category}";
  }
}

class ChannelDatabase {
  static final ChannelDatabase _instance = ChannelDatabase._internal();

  factory ChannelDatabase() => _instance;

  ChannelDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print('Initializing database...');
    return await openDatabase(
      join(await getDatabasesPath(), 'channels.db'),
      version: 1,
      onCreate: (db, version) {
        print('Database created');
        return db.execute("CREATE TABLE channels("
            "id TEXT PRIMARY KEY, "
            "imgPath TEXT, "
            "title TEXT, "
            "url TEXT, "
            "color INTEGER,"
            "category TEXT)");
      },
    );
  }

  Future<int> insert(Channel channel) async {
    final db = await database;
    return await db.insert(
      'channels',
      channel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Channel>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('channels');
    return List.generate(maps.length, (i) {
      return Channel.fromMap(maps[i]);
    });
  }

  Future<Channel?> getById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'channels',
      where: 'id = \'?\'',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Channel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(Channel channel) async {
    final db = await database;
    return await db.update(
      'channels',
      channel.toMap(),
      where: 'id = \'?\'',
      whereArgs: [channel.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(
      'channels',
      where: 'id = \'?\'',
      whereArgs: [id],
    );
  }

  void syncDatabases() async {}
}
