
class User {
  String username;
  String email;
  String id;
  String regNo;
  String? profilePic;
  String? address;
  String? bio;
  User({
    required this.email,
    required this.username,
    required this.id,
    required this.regNo,
    this.address,
    this.profilePic,
    this.bio,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'id': id,
      'regNo': regNo,
      'profilePic': profilePic,
      'address': address,
      'bio': bio,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      regNo: map['regNo'] ?? '',
      profilePic: map['profilePic'] ?? '',
      address: map['address'] ?? '',
      bio: map['bio'] ?? '',
    );
  }
}
