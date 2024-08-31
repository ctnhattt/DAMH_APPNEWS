class Video {
  late String videoUrl;
  late String username;
  late String caption;
  late int likes;
  late int dislikes;

  Video({
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.likes,
    required this.dislikes,
  });
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoUrl: json['videoUrl'],
      username: json['username'],
      caption: json['caption'],
      likes: json['likes'],
      dislikes: json['dislikes'],
    );
  }
  static List<Video> listFromJson(Map<String, dynamic> json) {
    List<Video> videos = [];
    json.forEach((key, value) {
      videos.add(Video.fromJson(value));
    });
    return videos;
  }
}
