import 'package:shared_preferences/shared_preferences.dart';

class TokenService {

  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;
  TokenService._internal();

  static const String _accessTokenKey = 'access_token';

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences before using
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save Token
  Future<void> saveToken(String token) async {
    await _prefs?.setString(_accessTokenKey, token);
  }

  /// Read Token
  Future<String?> getToken() async {
    return _prefs?.getString(_accessTokenKey);
  }

  /// Delete Token (Logout)
  Future<void> clearToken() async {
    await _prefs?.remove(_accessTokenKey);
  }
}
