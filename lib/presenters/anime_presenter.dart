import 'package:nitendo/models/anime_model.dart';
import 'package:nitendo/network/base_network.dart';

abstract class AnimeView {
  void showLoading();
  void hideLoading();
  void showAnimeList(List<Anime> showAnimeList);
  void showError(String massage);
}

class AnimePresenter{
  final AnimeView view;
  AnimePresenter(this.view);


  Future<void> loadAnimeData(String endpoint) async{
    try{
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      final animeList = data.map((json) => Anime.fromJson(json)). toList();
      view.showAnimeList(animeList);
      } catch (e){
        view.showError(e.toString());
      } finally {
        view.hideLoading();
      }
  }
}