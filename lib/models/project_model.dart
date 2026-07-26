class ProjectModel {
  final String name;
  final String category;
  final String description;
  final List<dynamic> tech;
  final String image;
  final String link;

  ProjectModel({
    required this.name,
    required this.category,
    required this.description,
    required this.tech,
    required this.image,
    required this.link,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json["name"] ?? "",
      category: json["category"] ?? "",
      description: json["description"] ?? "",
      tech: List<dynamic>.from(json["tech"] ?? []),
      image: json["image"] ?? "",
      link: json["link"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "description": description,
      "tech": tech,
      "image": image,
      "link": link,
    };
  }
}