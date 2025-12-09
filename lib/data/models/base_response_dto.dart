/// Base DTO for API responses
class BaseResponseDto {
  final bool isSuccess;
  final String? message;

  BaseResponseDto({
    required this.isSuccess,
    this.message,
  });
}

