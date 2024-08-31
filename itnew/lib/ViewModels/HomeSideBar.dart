import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:itnew/Models/Video.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeSideBar extends StatefulWidget {
  const HomeSideBar({super.key, required this.video});
  final Video video;
  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar> {
  @override
  Widget build(BuildContext context) {
    String solikes = widget.video.likes.toString();
    String sodislikes = widget.video.dislikes.toString();
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(
                Icons.thumb_up,
                color: Colors.white,
                size: 25,
              ),
              Text(
                solikes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.comment,
                color: Colors.white,
                size: 25,
              ),
              Text(
                sodislikes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Column(
            children: [
              Icon(
                Icons.share,
                color: Colors.white,
                size: 25,
              ),
              Text(
                'Share',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
