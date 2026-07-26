import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/project_model.dart';
import '../services/api_services.dart';

final projectProvider =
FutureProvider<List<ProjectModel>>((ref) async {
  return ApiService.getProjects();
});