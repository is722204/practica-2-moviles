import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_find_app/provider/music_provider.dart';
import 'package:provider/provider.dart';

import 'favorites.dart';
import 'music.dart';

class HomePage extends StatefulWidget {
  const HomePage({key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            Padding(
              padding: EdgeInsets.all(80.0),
              child: Text(
                !context.watch<MusicProvider>().getRecording
                    ? "Toque para escuchar"
                    : "Escuchando...",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  child: AvatarGlow(
                    glowColor: Colors.white,
                    endRadius: 130.0,
                    animate: context.watch<MusicProvider>().getRecording,
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      color: Color.fromARGB(0, 255, 0, 0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://assets.stickpng.com/images/580b57fcd9996e24bc43c538.png"),
                        radius: 80.0,
                      ),
                    ),
                    shape: BoxShape.circle,
                    curve: Curves.fastOutSlowIn,
                  ),
                  onTap: () async {
                    var retornado = await context.read<MusicProvider>().recor();
                    if (retornado != -1) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Music(
                                cancion: retornado,
                              )));
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                    radius: 20,
                  ),
                  onTap: ()async{
                    // final userCredential=await await context.read<MusicProvider>().signInWithGoogle();
                    // await FirebaseFirestore.instance.collection("users").doc(userCredential.user?.uid).set({"hola":"mundo"});
                    // print(userCredential.user);

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Favorites()));
                    
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      radius: 20,
                    ),
                    onTap: ()async{
                      // final userCredential=await await context.read<MusicProvider>().signInWithGoogle();
                      // await FirebaseFirestore.instance.collection("users").doc(userCredential.user?.uid).set({"hola":"mundo"});
                      // print(userCredential.user);
                      await _googleSignIn.signOut();
                      Navigator.of(context).pop();
                      
                    },
                  ),
                ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  
  
}
