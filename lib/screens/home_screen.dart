import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget statCard(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {
    return Expanded(

      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget skillTile(String skill, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            skill,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
            borderRadius:
            BorderRadius.circular(20),
          ),
        ],
      ),
    );
  }

  Widget quickButton(
      IconData icon,
      String text,
      Color color,
      ) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Production Ready Portfolio",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),

          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [

                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      "assets/images/profile.jpeg",
                    ),
                  ),

                  const SizedBox(width: 20),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Abdullah",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Flutter Developer",
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Building beautiful cross-platform apps.",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Statistics",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              statCard(
                Icons.folder,
                "Projects",
                "12",
                Colors.green,
              ),

              const SizedBox(width: 10),

              statCard(
                Icons.code,
                "Skills",
                "8",
                Colors.blue,
              ),

            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              statCard(
                Icons.work,
                "Experience",
                "1 Yr",
                Colors.orange,
              ),

              const SizedBox(width: 10),

              statCard(
                Icons.star,
                "Completed",
                "100%",
                Colors.purple,
              ),

            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Technical Skills",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          skillTile("Flutter", .90),
          skillTile("Dart", .85),
          skillTile("Firebase", .75),
          skillTile("REST API", .80),

          const SizedBox(height: 30),

          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              quickButton(
                Icons.person,
                "Profile",
                Colors.green,
              ),

              const SizedBox(width: 10),

              quickButton(
                Icons.work,
                "Projects",
                Colors.blue,
              ),

            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              quickButton(
                Icons.contact_mail,
                "Contact",
                Colors.orange,
              ),

              const SizedBox(width: 10),

              quickButton(
                Icons.settings,
                "Settings",
                Colors.purple,
              ),

            ],
          ),

          const SizedBox(height: 25),

        ],
      ),
    );
  }
}