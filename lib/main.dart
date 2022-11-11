import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_find_app/pages/home_page.dart';
import 'package:music_find_app/pages/sign_in.dart';
import 'package:music_find_app/provider/music_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (context) => MusicProvider(), 
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      darkTheme: ThemeData.dark(),
      home: SignIn(),    
    );
  }
}