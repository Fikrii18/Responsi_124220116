import 'package:flutter/material.dart';
import 'package:nitendo/lama/detail_animee/anime_detail.dart';
import 'package:nitendo/lama/models/anime_model.dart';
import 'package:nitendo/lama/presenters/anime_presenter.dart';
class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = 'amiibo';

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimeData(_currentEndpoint);
  }

  void _fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadAnimeData(endpoint);
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nitendo Amiibo List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => _fetchData('amiibo'),
                  child: Text("Home")),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () => _fetchData(''), child: Text("Favorite"))
                  ,SizedBox(
                width: 10,
              ),
            ],
          ),
          Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text("Error : ${_errorMessage}"))
                      : ListView.builder(
                          itemCount: _animeList.length,
                          itemBuilder: (context, index) {
                            final anime = _animeList[index];
                            return ListTile(
                                  //? Image.network(anime.imageUrl)
                                  //: Image.network(
                                      //'https://placehold.co/600x400'),
                              title: Text(anime.amiiboSeries),
                              subtitle: Text('Family ${anime.name}'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                            id: anime.id,
                                            endpoint: _currentEndpoint)));
                              },
                            );
                          }))
        ],
      ),
    );
  }
}
