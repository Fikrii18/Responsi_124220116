import 'package:flutter/material.dart';
import 'package:nitendo/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  final Set<String> favoriteIds;
  final List<Map<String, dynamic>> amiiboList;

  FavoriteScreen({required this.favoriteIds, required this.amiiboList});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int _selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    
    final favoriteAmiibos = widget.amiiboList
        .where((amiibo) => widget.favoriteIds.contains(amiibo['head'] + amiibo['tail']))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Amiibos', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: favoriteAmiibos.isEmpty
          ? Center(
              child: Text(
                'No favorites added yet!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: favoriteAmiibos.length,
              itemBuilder: (context, index) {
                final amiibo = favoriteAmiibos[index];
                final amiiboId = amiibo['head'] + amiibo['tail'];

                return Dismissible(
                  key: Key(amiiboId),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    
                    setState(() {
                      widget.favoriteIds.remove(amiiboId);
                    });

                    
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setStringList('favorites', widget.favoriteIds.toList());
                    });

                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed from Favorites'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        amiibo['gameSeries'],
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      onTap: () {
                        
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, 
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
          setState(() {
            _selectedIndex = index; 
          });

          if (index == 0) {
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            
          }
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
