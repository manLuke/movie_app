import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../models/account_details.dart';

enum LoginState { initial, requestedLogin, awaitingConfirmation }

class AuthProvider with ChangeNotifier {
  final StackRouter _router;
  final AuthService _authService;
  bool _isLoading = false;
  String? _error;
  AccountDetails? _user;
  bool _initialized = false;
  LoginState _loginState = LoginState.initial;

  AuthProvider({required AuthService authService, required StackRouter router})
      : _authService = authService,
        _router = router;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AccountDetails? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _initialized;

  LoginState get loginState => _loginState;
  String? _pendingRequestToken;

  Future<void> initializeApp() async {
    try {
      _setLoading(true);
      final storedSession = await _authService.getStoredSession();

      if (storedSession != null) {
        try {
          _user = await _authService.fetchAccountDetails();
          _initialized = true;
          _router.replaceNamed('/home');
          notifyListeners();
        } catch (e) {
          _authService.clearSession();
        }
      }
    } finally {
      _setLoading(false);
      _initialized = true;
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> requestSignIn() async {
    try {
      _setLoading(true);
      _setError(null);

      final requestToken = await _authService.createRequestToken();
      _pendingRequestToken = requestToken.requestToken;
      if (requestToken.success) {
        _loginState = LoginState.awaitingConfirmation;
        notifyListeners();
        await openSignInUrl();
      }
      return requestToken.success;
    } catch (e) {
      _setError('Failed to create request token: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> openSignInUrl() async {
    final url = Uri.parse(
        'https://www.themoviedb.org/authenticate/$_pendingRequestToken');
    await launchUrl(url);
  }

  Future<bool> confirmLogin() async {
    if (_pendingRequestToken == null) return false;

    try {
      return await submitSignIn(_pendingRequestToken!);
    } finally {
      _pendingRequestToken = null;
      _loginState = LoginState.initial;
    }
  }

  Future<bool> submitSignIn(String requestToken) async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.createSession(requestToken);
      _user = await _authService.fetchAccountDetails();
      _router.replaceNamed('/home');

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to complete authentication: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
