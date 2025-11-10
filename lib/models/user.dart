enum UserType { student, admin }

class User {
  String username;
  String email;
  String id;
  String regNo;
  UserType userType;
  String? profilePic;
  String? address;
  String? bio;
  User({
    required this.email,
    required this.username,
    required this.id,
    required this.regNo,
    this.userType = UserType.student,
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
      'userType': userType.name,
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
      userType: map['userType'] == 'admin' ? UserType.admin : UserType.student,
      profilePic: map['profilePic'] ?? '',
      address: map['address'] ?? '',
      bio: map['bio'] ?? '',
    );
  }
}
