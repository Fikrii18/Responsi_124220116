import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorit.dart';
import 'Detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> amiiboList = [];
  Set<String> favoriteIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAmiiboData();
    loadFavorites();
  }

  Future<void> fetchAmiiboData() async {
    final response = await http.get(Uri.parse('https://www.amiiboapi.com/api/amiibo'));
    if (response.statusCode == 200) {
      setState(() {
        amiiboList = List<Map<String, dynamic>>.from(json.decode(response.body)['amiibo']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load amiibo data');
    }
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  Future<void> toggleFavorite(String amiiboId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteIds.contains(amiiboId)) {
        favoriteIds.remove(amiiboId);
      } else {
        favoriteIds.add(amiiboId);
      }
    });
    await prefs.setStringList('favorites', favoriteIds.toList());

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(favoriteIds.contains(amiiboId)
            ? 'Added to Favorites'
            : 'Removed from Favorites'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nintendo Amiibo List', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 30),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteScreen(
                  favoriteIds: favoriteIds,
                  amiiboList: amiiboList,
                ),
              ),
            );
          }
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: amiiboList.length,
              itemBuilder: (context, index) {
                final amiibo = amiiboList[index];
                final amiiboId = amiibo['head'] + amiibo['tail'];
                final isFavorite = favoriteIds.contains(amiiboId);
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        amiibo['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      amiibo['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(amiibo['gameSeries']),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        toggleFavorite(amiiboId);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(amiibo: amiibo),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
