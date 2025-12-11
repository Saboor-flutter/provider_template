enum SharedPreferencesKeys {
  themeModeKey("theme-mode"),
  accessTokenKey("access-token");

  const SharedPreferencesKeys(this.keyText);

  final String keyText;
}

enum EndPoints {
  signIn('auth/login');

  final String url;

  const EndPoints(this.url);
}

enum BaseUrls {
  api('https://api.brunos.kitchen/bruno/api/v1/');

  final String url;

  const BaseUrls(this.url);
}

enum RegExpPattern {
  email(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    'Please enter a valid email address.',
  ),
  name(r'^[a-zA-Z]{3,}$', 'Enter valid name'),
  password(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$&*~€¥\\]).{8,}$',
    'must be 8+ characters with upper, lower, number, and special character.',
  );

  const RegExpPattern(this.pattern, this.errorMessage);

  final String pattern;
  final String errorMessage;
}



