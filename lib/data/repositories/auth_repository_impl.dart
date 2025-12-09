import '../../core/entities/auth_result.dart';
import '../../core/entities/sign_in_params.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/app_exception.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/sign_in_request_dto.dart';

/// Repository implementation - Data layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResult> signIn(SignInParams params) async {
    try {
      final requestDto = SignInRequestDto(
        email: params.email,
        password: params.password,
        deviceToken: params.deviceToken,
        deviceType: params.deviceType,
      );

      final responseDto = await _remoteDataSource.signIn(requestDto);

      if (responseDto.isSuccess && responseDto.data != null) {
        return AuthResult.success(
          user: responseDto.data!.toDomain(),
          message: responseDto.message,
        );
      } else {
        return AuthResult.failure(
          message: responseDto.message ?? 'Sign in failed',
        );
      }
    } on AppException catch (e) {
      return AuthResult.failure(message: e.message);
    } catch (e) {
      return AuthResult.failure(
        message: 'An unexpected error occurred',
      );
    }
  }
}

