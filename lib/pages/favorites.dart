
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_find_app/pages/itemFavorite.dart';
import 'package:music_find_app/provider/music_provider.dart';
import 'package:provider/provider.dart';


class Favorites extends StatelessWidget {
  const Favorites({key});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              ),
      // body: context.read<MusicProvider>().getFavorite.length<1?vacio(context):favoritas(context)
      body: FutureBuilder(
        future: context.watch<MusicProvider>().getFavorite, 
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) { 
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            return snapshot.data!.isEmpty?vacio(context): favoritas(context, snapshot.data);
          }
          
         },
      ),
    );
  }

  Column vacio(BuildContext context) {
    return Column(
      children: [
        EmptyWidget(
 packageImage: PackageImage.Image_1,
 title: 'NADA POR AQUÍ',
 subTitle: 'Escucha y agrega',
 titleTextStyle: TextStyle(
   fontSize: 28,
   color: Color.fromARGB(255, 73, 76, 85),
   fontWeight: FontWeight.w500,
 ),
 subtitleTextStyle: TextStyle(
   fontSize: 14,
   color: Color.fromARGB(255, 136, 142, 156),
 ),
 ),
 ElevatedButton(
onPressed: () {
    Navigator.of(context).pop();
},

child: Text('VOLVER PARA ESCUCHAR'),
)
      ],
    );
  }
  ListView favoritas(BuildContext context,lista) {
    return ListView.builder(
        itemCount: lista.length,//context.watch<MusicProvider>().getFavorite.length ,
        itemBuilder: (BuildContext context, int index) {
          return ItemFavorite(content:lista[index]);// context.watch<MusicProvider>().getFavorite[index]);
        });
  }
}