import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';

// import 'package:record/record.dart';

class MusicProvider with ChangeNotifier {
  bool _recording=false;
  String? _uid="";
  final List<dynamic> _favoriteList = [];

  
   bool get getRecording => _recording;
  Future<List> get getFavorite async{
    final resultado=await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    try {
      return resultado.data()!["favorites"];
    } catch (e) {
      return [];
    }
  }
  void addFavorite(dynamic musicObj) async{
    await FirebaseFirestore.instance
                          .collection("users")
                          .doc(_uid)
                          .update({"favorites":FieldValue.arrayUnion([musicObj])});
    notifyListeners();
  }

  void deleteFavorite(dynamic musicObj) async{
    await FirebaseFirestore.instance
                          .collection("users")
                          .doc(_uid)
                          .update({"favorites":FieldValue.arrayRemove([musicObj])});
    notifyListeners();
  }

  Future<bool> isNotInFavorite(dynamic musicObj)async {
    final favoritos=await getFavorite;
    return !favoritos.contains(musicObj);
  }

  //Grabar y retornar el obj con la info de la API para poder mostrarlo en pantalla MUSIC
  Future recor() async {
    final record = Record();
    if (await record.hasPermission()) {
      await record.start();
      _recording=true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 5));
      String? pathMusic = await record.stop();
      if (pathMusic != null) {
        File grabacion =  File(pathMusic);
        Uint8List grabacionBytes= grabacion.readAsBytesSync();
        String base64 = base64Encode(grabacionBytes);
        var url = Uri.parse('https://api.audd.io');
        var response = await http.post(
        url, 
        body: {
          'api_token': 'TOKEN',
          'audio': base64, 
          'return':'apple_music,spotify',
          },
        );
        _recording=false;
        notifyListeners();
        try{
          if(jsonDecode(response.body)["result"]!=null){
            return( jsonDecode(response.body)["result"]);
          }
          return -1;
        }catch (e){
          return -1;
        }  
      }

    

    }
  }


  Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
   final usuario=await FirebaseAuth.instance.signInWithCredential(credential);
   final existe=await FirebaseFirestore.instance
                          .collection("users")
                          .doc(usuario.user?.uid).get();
    _uid=usuario.user?.uid;
  if(!existe.exists){
    await FirebaseFirestore.instance
                          .collection("users")
                          .doc(_uid).set({"favorites":[]});
  }
   
}
}
