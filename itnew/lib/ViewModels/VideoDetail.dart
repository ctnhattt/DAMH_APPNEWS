import 'package:flutter/material.dart';
import 'package:itnew/Models/Video.dart';
import 'package:itnew/ViewModels/HomeSideBar.dart';

class VideoDetail extends StatelessWidget {
  const VideoDetail({super.key, required this.video});
  final Video video;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${video.username}",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            video.caption,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 2, // ------------------------- ĐỘ DÀY
            color: Colors.grey, // ----------------- MÀU SẮC
            indent: 1, // ---------------------------- LÙI SANG TRÁI
            endIndent: 1, // ------------------------- LÙI SANG PHẢI
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: HomeSideBar(
                  video: video,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
