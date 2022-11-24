import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Show>> shows;
  late Future<List<Top>> top;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
    top = fetchTop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 48, 144),
            title: const Text('MyAnimeList')
            ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Rated Airing',
                      style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 180.0,
                    child: FutureBuilder<List<Show>>(
                        future: shows,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        item: snapshot.data![index].malId,
                                        title: snapshot.data![index].title,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 0,
                                  child: Container(
                                    height: 150,
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 150,
                                            child: Image.network(snapshot
                                                .data![index]
                                                .images
                                                .jpg
                                                .image_url)),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, right: 3),
                                          child: Text(
                                            snapshot.data![index].title,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong :('));
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 20),
                child: Text(
                  'Top Rated Anime of All Time',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  child: FutureBuilder<List<Top>>(
                      future: top,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Color.fromARGB(255, 255, 255, 255),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(snapshot
                                        .data![index].images.jpg.image_url),
                                  ),
                                  title: Text(snapshot.data![index].title),
                                  subtitle: Text(
                                      'Rating: ${snapshot.data![index].score}'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            item: snapshot.data![index].malId,
                                            title: snapshot.data![index].title),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong :('));
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ),
            ])));
  }
}

class Show {
  final int malId;
  final String title;
  Images images;
  final double score;

  Show({
    required this.malId,
    required this.title,
    required this.images,
    required this.score,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      malId: json['mal_id'],
      title: json['title'],
      images: Images.fromJson(json['images']),
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
        'mal_id': malId,
        'title': title,
        'images': images,
        'score': score,
      };
}

class Images {
  final Jpg jpg;

  Images({required this.jpg});
  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: Jpg.fromJson(json['jpg']),
    );
  }

  Map<String, dynamic> toJson() => {
        'jpg': jpg.toJson(),
      };
}

class Jpg {
  String image_url;
  String small_image_url;
  String large_image_url;

  Jpg({
    required this.image_url,
    required this.small_image_url,
    required this.large_image_url,
  });

  factory Jpg.fromJson(Map<String, dynamic> json) {
    return Jpg(
      image_url: json['image_url'],
      small_image_url: json['small_image_url'],
      large_image_url: json['large_image_url'],
    );
  }
  //to json
  Map<String, dynamic> toJson() => {
        'image_url': image_url,
        'small_image_url': small_image_url,
        'large_image_url': large_image_url,
      };
}

Future<List<Show>> fetchShows() async {
  final response = await http
      .get(Uri.parse('https://api.jikan.moe/v4/top/anime?filter=airing'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['data'] as List;
    return jsonResponse.map((show) => Show.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}

class Top {
  final int malId;
  final String title;
  Images images;
  final double score;

  Top({
    required this.malId,
    required this.title,
    required this.images,
    required this.score,
  });

  factory Top.fromJson(Map<String, dynamic> json) {
    return Top(
      malId: json['mal_id'],
      title: json['title'],
      images: Images.fromJson(json['images']),
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
        'mal_id': malId,
        'title': title,
        'images': images,
        'score': score,
      };
}

Future<List<Top>> fetchTop() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['data'] as List;
    return jsonResponse.map((top) => Top.fromJson(top)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
