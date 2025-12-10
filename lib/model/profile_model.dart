class ProfileModel {
  String id;
  String fullname;
  String email;
  String profileImage;

  ProfileModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.profileImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
