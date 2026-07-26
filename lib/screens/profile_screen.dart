import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'edit_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Widget skillTile(String skill, double level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: level,
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return profile.when(
      loading: () => const LoadingWidget(
        message: "Loading Profile...",
      ),

      error: (e, s) => ErrorView(
        message: e.toString(),
        onRetry: () {
          ref.invalidate(profileProvider);
        },
      ),

      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(profileProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // PROFILE IMAGE
              Center(
                child: CircleAvatar(
                  radius: 70,
                  child: ClipOval(
                    child: Image.network(
                      data.image,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Image.asset(
                          "assets/images/profile.jpeg",
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Center(
                child: Text(
                  data.role,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const EditProfileScreen(),
                      ),
                    );

                    if (updated == true) {
                      ref.invalidate(profileProvider);
                    }
                  },
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "About Me",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Passionate Flutter Developer with experience in Flutter, Firebase, Riverpod, Hive, REST APIs and production-ready mobile application development.",
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(data.email),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(data.phone),
                ),
              ),

              Card(
                child: SwitchListTile(
                  value: Theme.of(context).brightness ==
                      Brightness.dark,
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text("Dark Theme"),
                  onChanged: (_) async {
                    await ref
                        .read(themeProvider.notifier)
                        .toggleTheme();
                  },
                ),
              ),

              const Card(
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Pakistan"),
                ),
              ),

              const Card(
                child: ListTile(
                  leading: Icon(Icons.school),
                  title: Text("BS Computer Science"),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Skills",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ...data.skills.map((skill) {
                return skillTile(
                  skill["name"].toString(),
                  (skill["level"] as num).toDouble(),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}