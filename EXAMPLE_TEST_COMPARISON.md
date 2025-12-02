# Practical Example: Testing with Both Approaches

## Scenario: Testing the Login API Call

### ❌ With Direct Instantiation (Your Suggestion)

```dart
// auth_service.dart
class AuthService {
  final ApiBaseHelper _apiClient = ApiBaseHelper();  // ❌ Can't control this
  final SharedPref _sharedPref = SharedPref();       // ❌ Can't control this
  
  Future<AuthResponse> signInApi(...) async {
    final response = await _apiClient.httpRequest(...);  // ❌ Makes REAL API call
    // ...
  }
}
```

**Problems:**
1. **Can't test without internet** - Makes real HTTP requests
2. **Can't test error scenarios** - Can't simulate network failures
3. **Slow tests** - Real API calls take time
4. **Unreliable tests** - API might be down, rate limited, etc.
5. **Can't test edge cases** - Can't control what the API returns

**Test would look like:**
```dart
test('login test', () async {
  final service = AuthService();  // ❌ Creates real dependencies
  
  // ❌ This makes a REAL API call to the server!
  final result = await service.signInApi(...);
  
  // ❌ Test depends on:
  // - Internet connection
  // - API server being up
  // - Valid credentials
  // - No rate limiting
});
```

---

### ✅ With Dependency Injection (Current Approach)

```dart
// auth_service.dart
class AuthService {
  final ApiBaseHelper _apiClient;
  final SharedPref _sharedPref;

  AuthService({
    required ApiBaseHelper apiClient,    // ✅ Can inject anything
    required SharedPref sharedPref,
  }) : _apiClient = apiClient,
       _sharedPref = sharedPref;
  
  Future<AuthResponse> signInApi(...) async {
    final response = await _apiClient.httpRequest(...);  // ✅ Uses injected dependency
    // ...
  }
}
```

**Benefits:**
1. **Can test offline** - Use mock objects
2. **Can test all scenarios** - Success, failure, network errors
3. **Fast tests** - No real network calls
4. **Reliable tests** - Full control over responses
5. **Can test edge cases** - Simulate any scenario

**Test looks like:**
```dart
// Create mock classes
class MockApiBaseHelper extends ApiBaseHelper {
  @override
  Future<dynamic> httpRequest(...) async {
    // ✅ Return controlled mock data
    return MockHttpResponse(
      statusCode: 200,
      body: '{"isSuccess": true, "data": {...}}',
    );
  }
}

class MockSharedPref extends SharedPref {
  final Map<String, String> _storage = {};
  
  @override
  void saveString(String key, String value) {
    _storage[key] = value;  // ✅ Just store in memory, no real SharedPreferences
  }
}

// Now write tests
test('login success scenario', () async {
  final mockApi = MockApiBaseHelper();
  final mockPref = MockSharedPref();
  
  final service = AuthService(
    apiClient: mockApi,   // ✅ Inject mock
    sharedPref: mockPref, // ✅ Inject mock
  );
  
  // ✅ No real API call! Fast and reliable
  final result = await service.signInApi(...);
  
  expect(result.isSuccess, true);
  expect(mockPref._storage['access-token'], isNotNull);
});

test('login network error scenario', () async {
  final mockApi = MockApiBaseHelper()..shouldThrowError = true;
  final mockPref = MockSharedPref();
  
  final service = AuthService(
    apiClient: mockApi,
    sharedPref: mockPref,
  );
  
  // ✅ Can test error handling
  final result = await service.signInApi(...);
  
  expect(result.isSuccess, false);
  expect(result.message, contains('error'));
});

test('login invalid credentials scenario', () async {
  final mockApi = MockApiBaseHelper()
    ..mockResponse = MockHttpResponse(
      statusCode: 401,
      body: '{"isSuccess": false, "message": "Invalid credentials"}',
    );
  
  final service = AuthService(
    apiClient: mockApi,
    sharedPref: MockSharedPref(),
  );
  
  // ✅ Can test specific error scenarios
  final result = await service.signInApi(...);
  
  expect(result.isSuccess, false);
  expect(result.message, 'Invalid credentials');
});
```

---

## Real-World Scenario: Different Environments

### With Dependency Injection ✅

```dart
// Development
final devApi = ApiBaseHelper()..baseUrl = 'https://dev-api.example.com';
final devAuthService = AuthService(
  apiClient: devApi,
  sharedPref: SharedPref(),
);

// Production
final prodApi = ApiBaseHelper()..baseUrl = 'https://api.example.com';
final prodAuthService = AuthService(
  apiClient: prodApi,
  sharedPref: SharedPref(),
);

// Testing
final testApi = MockApiBaseHelper();
final testAuthService = AuthService(
  apiClient: testApi,
  sharedPref: MockSharedPref(),
);
```

### With Direct Instantiation ❌

```dart
// ❌ All services use the same hardcoded implementation
// ❌ Can't easily switch between dev/prod/test
// ❌ Would need to modify the class itself
```

---

## Performance Comparison

### Dependency Injection
- **Test execution**: ~10ms (mock responses)
- **Can run 1000s of tests in seconds**
- **No external dependencies**

### Direct Instantiation
- **Test execution**: ~500ms+ per test (real API calls)
- **1000 tests = 500+ seconds (8+ minutes!)**
- **Requires internet, API server, etc.**

---

## Conclusion

**Dependency Injection = Professional, Testable, Maintainable Code** ✅

**Direct Instantiation = Quick but Unprofessional, Hard to Test** ❌

Your current code structure follows industry best practices! 🎯

