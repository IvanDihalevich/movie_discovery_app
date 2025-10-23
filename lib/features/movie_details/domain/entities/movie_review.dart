import 'package:equatable/equatable.dart';

class MovieReview extends Equatable {
  final String id;
  final String author;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String url;
  final double rating;

  const MovieReview({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, author, content, createdAt, updatedAt, url, rating];

  factory MovieReview.fromJson(Map<String, dynamic> json) {
    return MovieReview(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      url: json['url'] as String,
      rating: (json['author_details']['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'url': url,
      'author_details': {
        'rating': rating,
      },
    };
  }
}
