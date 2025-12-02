import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider_sample_app/repositories/auth_repository.dart';
import 'package:provider_sample_app/services/api_base_helper.dart';
import 'package:provider_sample_app/services/auth_service.dart';
import 'package:provider_sample_app/utills/shared_pref.dart';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  late final AuthRepository _authApiServices;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthResponse _authResponse = AuthResponse();

  AuthViewModel() {
    _authApiServices = AuthService(
      apiClient: ApiBaseHelper(),
      sharedPref: SharedPref(),
    );
  }

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  AuthResponse get authResponse => _authResponse;

  void setAuthResponse(AuthResponse response) {
    _authResponse = response;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> callSignInApi() async {
    setLoading(true);
    try {
      final SignInRequest signInRequest = SignInRequest(
        password: _passwordController.text,
        email: _emailController.text,
        deviceToken: 'wqwqw',
        deviceType: Platform.isAndroid ? 'android' : 'ios',
      );

      final AuthResponse response = await _authApiServices.signInApi(
        signInRequest: signInRequest,
      );
      
      setAuthResponse(response);
      setLoading(false);
      
      return response.isSuccess == true;
    } catch (e) {
      // Set error response
      setAuthResponse(
        AuthResponse(
          isSuccess: false,
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
      setLoading(false);
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
