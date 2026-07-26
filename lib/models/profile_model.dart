class ProfileModel {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String image;
  final List<Map<String, dynamic>> skills;

  ProfileModel({
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.image,
    required this.skills,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      skills: json['skills'] == null
          ? []
          : List<Map<String, dynamic>>.from(json['skills']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "role": role,
      "email": email,
      "phone": phone,
      "image": image,
      "skills": skills,
    };
  }
}