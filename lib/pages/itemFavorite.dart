import 'package:flutter/material.dart';
import 'package:music_find_app/pages/music.dart';
import 'package:music_find_app/provider/music_provider.dart';
import 'package:provider/provider.dart';

class ItemFavorite extends StatelessWidget {
  const ItemFavorite({key, required this.content});
  final Map content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Music(cancion: content,)));
        },
        child:Padding(
      padding: EdgeInsets.all(20.0),
      
        child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
                    child: Image.network(
                      content["spotify"]["album"]["images"][0]["url"]!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width/6,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 89, 35, 216),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(15),
                        )),
                    child: Column(
                      children: [
                        Text(
                          "${content["title"]}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${content["artist"]}",
                          style: TextStyle(color: Colors.white60, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) => AlertDialog(
                              title: Text("Eliminar de favoritos"),
                              content: Text(
                                  "El elemento será eliminado de tus favoritos. ¿Quieres continuar?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancelar")),
                                TextButton(
                                    onPressed: () {
                                      context.read<MusicProvider>().deleteFavorite(content);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Eliminar")),
                              ],
                            ));
                  },
                  icon: Icon(Icons.favorite),
                  color: Colors.white,
                  iconSize: 40.0),
            ],
          ),
      
        )
    );
  }
}