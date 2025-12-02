import 'dart:async';
import 'dart:convert';

import 'package:provider_sample_app/repositories/auth_repository.dart';
import 'package:provider_sample_app/utills/shared_pref.dart';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../utills/enums.dart';
import 'api_base_helper.dart';

class AuthService implements AuthRepository {
  final ApiBaseHelper _apiClient;
  final SharedPref _sharedPref;

  AuthService({
    required ApiBaseHelper apiClient,
    required SharedPref sharedPref,
  }) : _apiClient = apiClient,
       _sharedPref = sharedPref;

  @override
  Future<AuthResponse> signInApi({required SignInRequest signInRequest}) async {
    try {
      final response = await _apiClient.httpRequest(
        endPoint: EndPoints.signIn,
        requestType: 'POST',
        requestBody: signInRequest,
        params: '',
      );
      
      // Check HTTP status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final parsed = json.decode(response.body);
        AuthResponse authResponse = AuthResponse.fromJson(parsed);
        if (authResponse.isSuccess == true) {
          _sharedPref.saveString(
            SharedPreferencesKeys.accessTokenKey.keyText,
            authResponse.data?.clientToken ?? '',
          );
        }
        return authResponse;
      } else {
        // Handle HTTP error status codes
        final parsed = json.decode(response.body);
        return AuthResponse.fromJson(parsed);
      }
    } catch (e) {
      // Return error response on exception
      return AuthResponse(
        isSuccess: false,
        message: 'An error occurred. Please try again.',
      );
    }
  }
}
