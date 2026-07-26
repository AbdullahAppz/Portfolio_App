import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/contact_model.dart';
import '../models/profile_model.dart';
import '../models/project_model.dart';

class ApiService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String profileCollection = "profile";
  static const String profileDoc = "c5Xg9fBw40JwownVjLFP";

  static const String contactCollection = "contacts";
  static const String contactDoc = "info";

  static const String projectsCollection = "projects";

  //================ PROFILE =================

  static Future<ProfileModel> getProfile() async {
    final box = Hive.box("profile");

    try {
      final doc = await _firestore
          .collection(profileCollection)
          .doc(profileDoc)
          .get(const GetOptions(source: Source.serverAndCache));

      if (!doc.exists || doc.data() == null) {
        throw Exception("Profile document not found.");
      }

      final data = doc.data()!;

      await box.put("profile", jsonEncode(data));

      return ProfileModel.fromJson(data);
    } catch (e, stack) {
      debugPrint("PROFILE ERROR: $e");
      debugPrintStack(stackTrace: stack);

      final cache = box.get("profile");

      if (cache != null) {
        return ProfileModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(cache)),
        );
      }

      rethrow;
    }
  }

  //================ PROJECTS =================

  static Future<List<ProjectModel>> getProjects() async {
    final box = Hive.box("projects");

    try {
      final snapshot = await _firestore
          .collection(projectsCollection)
          .get(const GetOptions(source: Source.serverAndCache));

      final projects = snapshot.docs
          .map((doc) => ProjectModel.fromJson(doc.data()))
          .toList();

      await box.put(
        "projects",
        jsonEncode(
          projects.map((e) => e.toJson()).toList(),
        ),
      );

      return projects;
    } catch (e, stack) {
      debugPrint("PROJECT ERROR: $e");
      debugPrintStack(stackTrace: stack);

      final cache = box.get("projects");

      if (cache != null) {
        final List decoded = jsonDecode(cache);

        return decoded
            .map((e) => ProjectModel.fromJson(
          Map<String, dynamic>.from(e),
        ))
            .toList();
      }

      rethrow;
    }
  }

  //================ CONTACT =================

  static Future<ContactModel> getContact() async {
    final box = Hive.box("contact");

    try {
      final doc = await _firestore
          .collection(contactCollection)
          .doc(contactDoc)
          .get(const GetOptions(source: Source.serverAndCache));

      if (!doc.exists || doc.data() == null) {
        throw Exception("Contact document not found.");
      }

      final data = doc.data()!;

      await box.put("contact", jsonEncode(data));

      return ContactModel.fromJson(data);
    } catch (e, stack) {
      debugPrint("CONTACT ERROR: $e");
      debugPrintStack(stackTrace: stack);

      final cache = box.get("contact");

      if (cache != null) {
        return ContactModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(cache)),
        );
      }

      rethrow;
    }
  }

  //================ UPDATE PROFILE =================

  static Future<void> updateProfile(
      ProfileModel profile) async {
    try {
      await _firestore
          .collection(profileCollection)
          .doc(profileDoc)
          .set(
        profile.toJson(),
        SetOptions(merge: true),
      );

      final box = Hive.box("profile");

      await box.put(
        "profile",
        jsonEncode(profile.toJson()),
      );
    } catch (e, stack) {
      debugPrint("UPDATE PROFILE ERROR: $e");
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  //================ UPDATE CONTACT =================

  static Future<void> updateContact(
      ContactModel contact) async {
    try {
      await _firestore
          .collection(contactCollection)
          .doc(contactDoc)
          .set(
        contact.toJson(),
        SetOptions(merge: true),
      );

      final box = Hive.box("contact");

      await box.put(
        "contact",
        jsonEncode(contact.toJson()),
      );
    } catch (e, stack) {
      debugPrint("UPDATE CONTACT ERROR: $e");
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }
}