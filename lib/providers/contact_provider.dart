import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contact_model.dart';
import '../services/api_services.dart';

final contactProvider =
FutureProvider<ContactModel>((ref) async {
  return ApiService.getContact();
});