import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  final String imgUrl;

  const FullScreen({super.key, required this.imgUrl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {

  Future<void> setWallpaper()async{
    try{
      int location=WallpaperManager.HOME_SCREEN;
      var file= await DefaultCacheManager().getSingleFile(widget.imgUrl);
      bool result=await WallpaperManager.setWallpaperFromFile(file.path, location);
      print("Set Wallpaper : $result");
      SnackBar(content: Text("Wall Paper set successully"));
    }catch(e){
      print("Error setting wallpaper: $e");
      SnackBar(content: Text("Error in setting Wall Paper"));
    }

    //for remove wallpaper
    // result=await WallpaperManager.clearWallpaper();
    // print("Clear Wallpaper: $result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Image.network(widget.imgUrl,fit: BoxFit.cover,)),

          Container(
            height: 80,
            width: double.infinity,
            color: Colors.black,
            child: TextButton(
                onPressed: () {
                  setWallpaper();
                },
                child: const Text(
                  "Set Wallpaper",
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
