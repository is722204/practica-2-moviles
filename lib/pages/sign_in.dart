import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_find_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../provider/music_provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset("assets/fondo.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Sign in",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 150.0,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/logo.png"),
                    radius: 80,
                  ),
                  SizedBox(
                    height: 150.0,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      await context
                          .read<MusicProvider>()
                          .signInWithGoogle();
                      
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: FaIcon(FontAwesomeIcons.google),
                    label: Text("Iniciar sesión con google"),
                    backgroundColor: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
