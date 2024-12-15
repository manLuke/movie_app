import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl;
  final String _apiKey;
  final String _accessToken;
  String? _sessionId;

  ApiService({
    required String baseUrl,
    required String apiKey,
    required String accessToken,
  })  : _baseUrl = baseUrl,
        _apiKey = apiKey,
        _accessToken = accessToken;

  void setSessionId(String session) {
    _sessionId = session;
  }

  void clearSessionId() {
    _sessionId = null;
  }

  /// Makes a GET request to the specified [endpoint].
  /// Accepts [params] for query parameters and returns a parsed JSON response.
  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    final uri = _buildUri(endpoint, params);
    final headers = _buildHeaders();

    final response = await http.get(uri, headers: headers);
    return _processResponse(response);
  }

  /// Makes a POST request to the specified [endpoint].
  /// Accepts [body] for the request payload and [params] for query parameters.
  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? params}) async {
    final uri = _buildUri(endpoint, params);
    final headers = _buildHeaders();

    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
    return _processResponse(response);
  }

  /// Makes a DELETE request to the specified [endpoint].
  Future<dynamic> delete(String endpoint, {Map<String, String>? params}) async {
    final uri = _buildUri(endpoint, params);
    final headers = _buildHeaders();

    final response = await http.delete(uri, headers: headers);
    return _processResponse(response);
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };

    return headers;
  }

  /// Constructs the URI with required query parameters
  Uri _buildUri(String endpoint, Map<String, String>? params) {
    final queryParams = {
      'apiKey': _apiKey,
      if (_sessionId != null) 'sessionId': _sessionId!,
      if (params != null) ...params,
    };

    return Uri.parse('$_baseUrl$endpoint')
        .replace(queryParameters: queryParams);
  }

  /// Handles and processes the HTTP response.
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() {
    return 'ApiException: HTTP $statusCode - $message';
  }
}
