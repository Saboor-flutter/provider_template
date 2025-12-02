import 'package:provider_sample_app/models/responses/auth_response.dart';

import '../models/requests/sign_in_request.dart';

abstract class AuthRepository {
  Future<AuthResponse> signInApi({required SignInRequest signInRequest});
}