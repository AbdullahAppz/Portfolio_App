import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_model.dart';
import '../providers/project_provider.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() =>
      _ProjectsScreenState();
}

class _ProjectsScreenState
    extends ConsumerState<ProjectsScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectProvider);

    return projects.when(
      loading: () =>
      const LoadingWidget(message: "Loading Projects..."),

      error: (e, s) => ErrorView(
        message: e.toString(),
        onRetry: () {
          ref.invalidate(projectProvider);
        },
      ),

      data: (list) {
        final filtered = list.where((project) {
          final query = search.toLowerCase();

          return project.name.toLowerCase().contains(query) ||
              project.description.toLowerCase().contains(query) ||
              project.tech.any(
                    (tech) => tech
                    .toString()
                    .toLowerCase()
                    .contains(query),
              );
        }).toList();

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(projectProvider);
          },
          child: filtered.isEmpty
              ? const EmptyWidget(
            title: "No Projects Found",
            subtitle:
            "Try searching with another keyword.",
            icon: Icons.folder_off,
          )
              : ListView(
            padding: const EdgeInsets.all(16),
            children: [

              const Text(
                "Projects",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Explore some of my recent work.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  hintText: "Search Projects",
                  prefixIcon:
                  const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),

              const SizedBox(height: 25),

              ...filtered.map(
                    (project) => Padding(
                  padding:
                  const EdgeInsets.only(bottom: 22),
                  child: InkWell(
                    borderRadius:
                    BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProjectDetailsScreen(
                                project: project,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: project.image.isEmpty
                                ? Image.asset(
                              "assets/images/project_placeholder.png",
                              fit: BoxFit.cover,
                            )
                                : CachedNetworkImage(
                              imageUrl:
                              project.image,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) =>
                              const Center(
                                child:
                                CircularProgressIndicator(),
                              ),
                              errorWidget:
                                  (context,
                                  url,
                                  error) =>
                                  Image.asset(
                                    "assets/images/project_placeholder.png",
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [

                                Text(
                                  project.name,
                                  style:
                                  const TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 12),

                                Text(
                                  project.description,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.grey,
                                    height: 1.4,
                                  ),
                                ),

                                const SizedBox(
                                    height: 18),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                  project.tech
                                      .map(
                                        (tech) =>
                                        Chip(
                                          backgroundColor:
                                          Colors.green.shade50,
                                          side:
                                          BorderSide.none,
                                          label:
                                          Text(
                                            tech
                                                .toString(),
                                            style:
                                            const TextStyle(
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                  )
                                      .toList(),
                                ),

                                const SizedBox(
                                    height: 18),

                                Row(
                                  children: [

                                    const Icon(
                                      Icons.touch_app,
                                      color:
                                      Colors.green,
                                      size: 18,
                                    ),

                                    const SizedBox(
                                        width: 8),

                                    const Text(
                                      "Tap to view details",
                                      style:
                                      TextStyle(
                                        color: Colors
                                            .green,
                                        fontWeight:
                                        FontWeight
                                            .w600,
                                      ),
                                    ),

                                    const Spacer(),

                                    Icon(
                                      Icons
                                          .arrow_forward_ios,
                                      color: Colors
                                          .grey
                                          .shade600,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
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
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Project Image
            SizedBox(
              width: double.infinity,
              height: 250,
              child: project.image.isEmpty
                  ? Image.asset(
                "assets/images/project_placeholder.png",
                fit: BoxFit.cover,
              )
                  : CachedNetworkImage(
                imageUrl: project.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, __, ___) =>
                    Image.asset(
                      "assets/images/project_placeholder.png",
                      fit: BoxFit.cover,
                    ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  /// Title
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Category
                  Row(
                    children: [

                      const Icon(
                        Icons.category,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        project.category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Technologies
                  const Text(
                    "Technologies Used",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                        Colors.green.shade50,
                        side: BorderSide.none,
                        label: Text(
                          tech.toString(),
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 30),

                  /// Description
                  const Text(
                    "Project Description",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    project.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text(
                        "Open Project",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () =>
                          openProject(context),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back"),
                      onPressed: () {
                        Navigator.pop(context);
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