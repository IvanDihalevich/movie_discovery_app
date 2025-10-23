import 'package:equatable/equatable.dart';

class MovieVideo extends Equatable {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  const MovieVideo({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  @override
  List<Object?> get props => [id, key, name, site, type, official];

  factory MovieVideo.fromJson(Map<String, dynamic> json) {
    return MovieVideo(
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      site: json['site'] as String,
      type: json['type'] as String,
      official: json['official'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'site': site,
      'type': type,
      'official': official,
    };
  }

  // Get YouTube URL for the video
  String get youtubeUrl {
    if (site.toLowerCase() == 'youtube') {
      return 'https://www.youtube.com/watch?v=$key';
    }
    return '';
  }

  // Get YouTube thumbnail URL
  String get youtubeThumbnailUrl {
    if (site.toLowerCase() == 'youtube') {
      return 'https://img.youtube.com/vi/$key/maxresdefault.jpg';
    }
    return '';
  }
}
