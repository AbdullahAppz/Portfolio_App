class ContactModel {
  final String email;
  final String phone;
  final String linkedin;
  final String github;
  final String portfolio;

  ContactModel({
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.github,
    required this.portfolio,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      linkedin: json['linkedin']?.toString() ?? '',
      github: json['github']?.toString() ?? '',
      portfolio: json['portfolio']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "phone": phone,
      "linkedin": linkedin,
      "github": github,
      "portfolio": portfolio,
    };
  }
}