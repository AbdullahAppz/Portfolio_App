import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAvatar extends StatefulWidget {
  final String? imagePath;
  final Function(String)? onImageChanged;

  const ProfileAvatar({
    super.key,
    this.imagePath,
    this.onImageChanged,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? image;

  @override
  void initState() {
    super.initState();

    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      image = File(widget.imagePath!);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      image = File(picked.path);
    });

    widget.onImageChanged?.call(picked.path);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile image updated successfully."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: image != null
              ? FileImage(image!)
              : const AssetImage("assets/images/profile.jpeg")
          as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: FloatingActionButton.small(
            heroTag: "profile_image",
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: pickImage,
            child: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }
}