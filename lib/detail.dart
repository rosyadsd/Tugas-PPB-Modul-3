import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final int item;
  final String title;
  const DetailPage({Key? key, required this.item, required this.title})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Episode> episodes;

  @override
  void initState() {
    super.initState();
    episodes = fetchEpisodes(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
           backgroundColor: Color.fromARGB(255, 0, 48, 144),
          title: Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<Episode>(
              future: episodes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child:
                            Image.network(snapshot.data!.images.jpg.image_url),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        snapshot.data!.title,
                        style: GoogleFonts.roboto(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'MAL Score: ' + snapshot.data!.score.toString(),
                      style: GoogleFonts.roboto(),
                    ),
                    Text(
                      'Airing Date: ' + snapshot.data!.Airing.broadcast,
                      style: GoogleFonts.roboto(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 20),
                      child: Text(
                        snapshot.data!.synopsis,
                        style: GoogleFonts.roboto(letterSpacing: 0.5),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ]));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}

class Episode {
  final String title;
  final int malId;
  Images images;
  final double score;
  Air Airing;
  final String synopsis;

  Episode(
      {required this.title,
      required this.malId,
      required this.images,
      required this.score,
      required this.Airing,
      required this.synopsis});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title'],
      malId: json['mal_id'],
      images: Images.fromJson(json['images']),
      score: json['score'],
      Airing: Air.fromJson(json['aired']),
      synopsis: json['synopsis'],
    );
  }
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

class Air {
  String broadcast;

  Air({required this.broadcast});
  factory Air.fromJson(Map<String, dynamic> json) {
    return Air(
      broadcast: json['string'],
    );
  }
  Map<String, dynamic> toJson() => {
        'string': broadcast,
      };
}

Future<Episode> fetchEpisodes(malId) async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/anime/$malId'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Episode.fromJson(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
