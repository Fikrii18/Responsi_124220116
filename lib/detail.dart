import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetailScreen extends StatefulWidget {
  final Map amiibo;

  DetailScreen({required this.amiibo});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  
  Future<void> checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final amiiboId = widget.amiibo['head'] + widget.amiibo['tail'];
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      isFavorite = favorites.contains(amiiboId);
    });
  }

  
  Future<void> toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    
    final amiiboId = widget.amiibo['head'] + widget.amiibo['tail'];

    if (favorites.contains(amiiboId)) {
      
      favorites.remove(amiiboId);
    } else {
      
      favorites.add(amiiboId);

      
      List<String> favoriteDetails = prefs.getStringList('favoriteDetails') ?? [];
      favoriteDetails.add(json.encode(widget.amiibo));
      await prefs.setStringList('favoriteDetails', favoriteDetails);
    }

    
    await prefs.setStringList('favorites', favorites);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final releaseDates = widget.amiibo['release'] ?? {};
    final releaseAU = releaseDates['au'] ?? 'Not available';
    final releaseEU = releaseDates['eu'] ?? 'Not available';
    final releaseJP = releaseDates['jp'] ?? 'Not available';
    final releaseNA = releaseDates['na'] ?? 'Not available';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.amiibo['name'], style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: toggleFavorite,  
          ),
        ],
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.amiibo['image'],
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            Text(
              widget.amiibo['name'],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            
            DetailRow(title: 'Character:', content: widget.amiibo['character']),
            DetailRow(title: 'Amiibo Series:', content: widget.amiibo['amiiboSeries']),
            DetailRow(title: 'Game Series:', content: widget.amiibo['gameSeries']),
            DetailRow(title: 'Type:', content: widget.amiibo['type']),

            SizedBox(height: 20),

            
            Text(
              'Release Dates:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(title: ' - Australia:', content: releaseAU),
                  DetailRow(title: ' - Europe:', content: releaseEU),
                  DetailRow(title: ' - Japan:', content: releaseJP),
                  DetailRow(title: ' - North America:', content: releaseNA),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String content;

  DetailRow({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$title $content',
        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
      ),
    );
  }
}
