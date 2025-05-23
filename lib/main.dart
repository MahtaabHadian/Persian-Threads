import 'package:flutter/material.dart';
import 'package:persian_threads/post_card.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Card Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PostCards(

                  username: 'Mahtaab',
                  time: '17:07',
                  postText:
                  'This portfolio is a collection of my digital and conceptual artworks, showcasing a blend of imagination, cinematic atmospheres, and visual storytelling.',
                  imageUrl:
                  'https://a.storyblok.com/f/178900/800x420/d8889e2cbf/the-guy-she-was-interested-in-wasnt-a-guy-at-all.jpg', // Replace with a real URL
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                   mypost: true,
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 10),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText: 'This is a text-only post, without any image or voice.',
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                  mypost: false,
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 10),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:07',
                  postText: 'This should be a post with voice',
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                  mypost: false,
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                ),
                SizedBox(height: 10),
                PostCards(
                  username: 'Mahtaab',
                  time: '17:10',
                  postText: 'I WILL TATTOO THIS CLIP!',
                  videoUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // Replace with a real URL
                  profilePicUrl:
                  'https://i.redd.it/5pi46xym7d281.jpg',
                  mypost: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




