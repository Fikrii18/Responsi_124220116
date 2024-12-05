class Anime{
  final int id;
  final String amiiboSeries;
  final String character;
  final String gameSeries;
  final String name;

  Anime ({
    required this.id,
    required this.amiiboSeries,
    required this.character,
    required this.name,
    required this.gameSeries,
  });

  factory Anime.fromJson(Map<String, dynamic> json){
    return Anime(id: json['id'] ?? 0, 
    amiiboSeries: json['amiiboSeries'], 
    //imageUrl: (json['images'] != null && json['images'].isNotEmpty)?
    //json['images'] [0] 
    //: 'https://placehold.co/600x400',
    gameSeries:json['gameSeries'] ,
    character:json['character'] ,
    name: json['name']);
    }
}
//"amiiboSeries": "Legend Of Zelda",
            //"character": "Zelda",
            //"gameSeries": "The Legend of Zelda",
            //"head": "01010000",
            //"image": "https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/icon_01010000-03520902.png",
            //"name": "Toon Zelda - The Wind Waker",
            //"release": {
                //"au": "2016-12-03",
                //"eu": "2016-12-02",
                //"jp": "2016-12-01",
                //"na": "2016-12-02"
            //},
            //"tail": "03520902",
            //"type": "Figure"