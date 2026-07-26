import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../services/api_services.dart';

final profileProvider =
FutureProvider<ProfileModel>((ref) async {
  return ApiService.getProfile();
});