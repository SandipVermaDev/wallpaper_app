import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/full_screen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;

  fetchapi() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          'Authorization':
              'EJ1NN1OR4v7Pm7nwVYLNda9yGTE97UMklb8vMqxAGZed8BkNwNg7xS3n'
        }).then((value) {
      // print(value.body);
      Map result = jsonDecode(value.body);
      // print(result);
      setState(() {
        images = result['photos'];
      });
      // print(images);
      // print(images[5]);
    });
  }

  loadMore() async {
    setState(() {
      page += 1;
    });
    String uri =
        'https://api.pexels.com/v1/curated?per_page=80&page=$page';
    await http.get(Uri.parse(uri), headers: {
      'Authorization':
          'EJ1NN1OR4v7Pm7nwVYLNda9yGTE97UMklb8vMqxAGZed8BkNwNg7xS3n'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchapi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Grid view
          Expanded(
              child: GridView.builder(
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 2 / 3),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreen(imgUrl: images[index]['src']['large2x']),));
                },
                child: Image.network(
                  images[index]['src']['tiny'],
                  fit: BoxFit.cover,
                ),
              );
            },
          )),

          //Bottom button
          Container(
            height: 80,
            width: double.infinity,
            color: Colors.black,
            child: TextButton(
                onPressed: loadMore,
                child: const Text(
                  "Load More",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
