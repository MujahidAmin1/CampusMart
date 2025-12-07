class Review {
  final String id;
  final String reviewerId;
  final String sellerId;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.reviewerId,
    required this.sellerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as String,
    reviewerId: json['reviewerId'] as String,
    sellerId: json['sellerId'] as String,
    rating: json['rating'] as int,
    comment: json['comment'] as String,
    createdAt: json['createdAt'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'reviewerId': reviewerId,
    'sellerId': sellerId,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt,
  };
}
