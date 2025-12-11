import 'enums.dart';

String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return 'First name is required';
  }
  RegExp regex = RegExp(RegExpPattern.name.pattern);
  if (regex.hasMatch(value)) {
    return RegExpPattern.name.errorMessage;
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  RegExp regex = RegExp(RegExpPattern.email.pattern);
  if (!regex.hasMatch(value)) {
    return RegExpPattern.email.errorMessage;
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  RegExp regex = RegExp(RegExpPattern.password.pattern);
  if (!regex.hasMatch(value)) {
    return RegExpPattern.password.errorMessage;
  }
  return null;
}
