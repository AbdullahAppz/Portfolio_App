import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/project_model.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  Future<void> openProject(BuildContext context) async {
    if (project.link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Project link not available."),
        ),
      );
      return;
    }

    final Uri uri = Uri.parse(project.link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open project."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        project.image.isNotEmpty &&
            project.image.startsWith("http");

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(project.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// Project Image
            SizedBox(
              height: 250,
              width: double.infinity,
              child: hasImage
                  ? CachedNetworkImage(
                imageUrl: project.image,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                const Center(
                  child:
                  CircularProgressIndicator(),
                ),
                errorWidget:
                    (_, __, ___) => Image.asset(
                  "assets/images/project_placeholder.png",
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                "assets/images/project_placeholder.png",
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    project.name,
                    style:
                    const TextStyle(
                      fontSize: 30,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const Icon(
                        Icons.category,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        project.category,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 0,
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                          16),
                      child: Text(
                        project.description,
                        style:
                        const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Technologies Used",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: project.tech
                        .map(
                          (tech) => Chip(
                        backgroundColor:
                        Colors.green
                            .shade50,
                        side:
                        BorderSide.none,
                        avatar:
                        const Icon(
                          Icons.code,
                          size: 18,
                        ),
                        label: Text(
                          tech.toString(),
                          style:
                          const TextStyle(
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width:
                    double.infinity,
                    height: 55,
                    child:
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.open_in_new,
                      ),
                      label: const Text(
                        "Open Project",
                      ),
                      onPressed: () =>
                          openProject(
                              context),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width:
                    double.infinity,
                    height: 55,
                    child:
                    OutlinedButton.icon(
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      label:
                      const Text("Back"),
                      onPressed: () {
                        Navigator.pop(
                            context);
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}