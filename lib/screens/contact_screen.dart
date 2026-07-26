import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/contact_provider.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  Future<void> open(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Widget contactTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactProvider);

    return contact.when(
      loading: () => const LoadingWidget(
        message: "Loading Contact...",
      ),

      error: (e, s) => ErrorView(
        message: e.toString(),
        onRetry: () {
          ref.invalidate(contactProvider);
        },
      ),

      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(contactProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.contact_mail,
                  color: Colors.white,
                  size: 55,
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Get In Touch",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              contactTile(
                icon: Icons.email,
                title: "Email",
                value: data.email,
                color: Colors.red,
                onTap: () => open("mailto:${data.email}"),
              ),

              contactTile(
                icon: Icons.phone,
                title: "Phone",
                value: data.phone,
                color: Colors.green,
                onTap: () => open("tel:${data.phone}"),
              ),

              contactTile(
                icon: FontAwesomeIcons.linkedin,
                title: "LinkedIn",
                value: data.linkedin,
                color: Colors.blue,
                onTap: () => open(data.linkedin),
              ),

              contactTile(
                icon: FontAwesomeIcons.github,
                title: "GitHub",
                value: data.github,
                color: Colors.black,
                onTap: () => open(data.github),
              ),

              contactTile(
                icon: Icons.web,
                title: "Portfolio",
                value: data.portfolio,
                color: Colors.orange,
                onTap: () => open(data.portfolio),
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Portfolio App v1.0.0",
                  style: TextStyle(
                    color: Colors.grey,
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