import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../services/api_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/success_snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController =
  TextEditingController(text: "Abdullah");

  final emailController =
  TextEditingController(
      text: "abdullah@email.com");

  final phoneController =
  TextEditingController(
      text: "+92 3001234567");

  String imagePath = "";
  bool isSaving = false;

  Future<void> saveProfile() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {

      final profile = ProfileModel(
        name: nameController.text.trim(),
        role: "Flutter Developer",
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        image: imagePath.isEmpty
            ? "assets/images/profile.jpeg"
            : imagePath,
        skills: const [
          {"name": "Flutter", "level": 0.90},
          {"name": "Dart", "level": 0.85},
          {"name": "Firebase", "level": 0.80},
          {"name": "Riverpod", "level": 0.85},
        ],
      );

      await ApiService.updateProfile(profile);

      if (!mounted) return;

      SuccessSnackBar.show(
        context,
        "Profile Updated Successfully",
      );

      Navigator.pop(context, true);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            Center(
              child: ProfileAvatar(
                imagePath: imagePath,
                onImageChanged: (path) {
                  setState(() {
                    imagePath = path;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your name";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: emailController,
              keyboardType:
              TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Please enter email";
                }

                if (!value.contains("@")) {
                  return "Enter a valid email";
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Please enter phone";
                }

                return null;
              },
            ),

            const SizedBox(height: 30),

            isSaving
                ? const Center(
              child:
              CircularProgressIndicator(),
            )
                : CustomButton(
              text: "Save Changes",
              icon: Icons.save,
              onPressed: saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}