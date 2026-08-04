import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../services/firebase_auth.dart';
import '../widgets/logout_dailouge.dart';
import 'contact_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'project_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends ConsumerState<MainNavigation> {

  int currentIndex = 0;

  Future<void> logout() async {
    final confirm = await LogoutDialog.show(context);

    if (!confirm) return;

    await FirebaseAuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onNavigate: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      const ProfileScreen(),
      const ProjectsScreen(),
      const ContactScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolio"),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              ref
                  .read(themeProvider.notifier)
                  .toggleTheme();
            },
          ),

          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: "Portfolio App",
                applicationVersion: "1.0.0",
                applicationLegalese:
                "Developed using Flutter",
                children: const [
                  SizedBox(height: 10),
                  Text(
                    "Production Ready Portfolio Application",
                  ),
                ],
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[currentIndex],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),

          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: "Projects",
          ),

          NavigationDestination(
            icon: Icon(Icons.contact_mail_outlined),
            selectedIcon: Icon(Icons.contact_mail),
            label: "Contact",
          ),
        ],
      ),
    );
  }
}