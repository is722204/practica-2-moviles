import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/music_provider.dart';

class Music extends StatelessWidget {
  const Music({key, required this.cancion});
  final Map cancion;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Here you go'),
          actions: [
            IconButton(onPressed: ()async{
              await context.read<MusicProvider>().isNotInFavorite(cancion)?showDialog(
                        context: context,
                        builder: (builder) => AlertDialog(
                              title: Text("¿Agregar a favoritos?"),
                              content: Text(
                                  "La canción se agregará a tus favoritos, ¿desea continuar?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancelar")),
                                TextButton(
                                    onPressed: () {
                                      context.read<MusicProvider>().addFavorite(cancion);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Agregar")),
                              ],
                            )):null;
              
            }, icon: Icon(Icons.favorite))
          ],
        ),
        body: Column(
          children: [
            Image.network(
                "${cancion["spotify"]["album"]["images"][0]["url"]}"),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                child: Column(children: [
                  Text(
                    "${cancion["title"]}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text( 
                    "${cancion["album"]}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${cancion["artist"]}",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text("${cancion["release_date"]}", style: TextStyle(color: Colors.grey))
                ]),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: const Text("Abrir con:"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(onPressed: (){
                          _launchUrl(cancion["spotify"]["external_urls"]["spotify"]);
                        }, icon: FaIcon(FontAwesomeIcons.spotify ), iconSize: 40,),
                        IconButton(onPressed: (){
                          _launchUrl(cancion["song_link"]);
                        }, icon: FaIcon(FontAwesomeIcons.music), iconSize: 40,),
                        IconButton(onPressed: (){
                          _launchUrl(cancion["apple_music"]["url"]);
                        }, icon: FaIcon(FontAwesomeIcons.apple), iconSize: 40,),
                      ],
                    ),
                  ],
                ),
              )
                ],
              ),
            )
          ],
        ));;
  }

  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}