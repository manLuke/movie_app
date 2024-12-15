import 'package:shared_preferences/shared_preferences.dart';
import '../models/request_token.dart';
import '../models/session.dart';
import '../models/account_details.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService({required ApiService apiService}) : _apiService = apiService;

  /// Creates a new request token
  Future<RequestToken> createRequestToken() async {
    final response = await _apiService.get('/authentication/token/new');
    return RequestToken.fromJson(response);
  }

  /// Creates a new session using the request token
  Future<void> createSession(String requestToken) async {
    final response = await _apiService.post(
      '/authentication/session/new',
      body: {'request_token': requestToken},
    );

    final session = Session.fromJson(response);

    await _storeSession(session.sessionId);
    _apiService.setSessionId(session.sessionId);
  }

  /// Fetches account details using the stored session ID
  Future<AccountDetails> fetchAccountDetails() async {
    final storedSession = await getStoredSession();

    if (storedSession == null) {
      throw Exception('No session ID found. Please log in.');
    }

    _apiService.setSessionId(storedSession);

    final response = await _apiService.get('/account');
    return AccountDetails.fromJson(response);
  }

  /// Stores the session ID in local storage
  Future<void> _storeSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', sessionId);
  }

  Future<void> _clearStoredSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
  }

  void clearSession() {
    _apiService.clearSessionId();
    _clearStoredSession();
  }

  /// Retrieves the stored session ID from local storage
  Future<String?> getStoredSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }
}
