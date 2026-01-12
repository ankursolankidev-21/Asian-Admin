import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyEmail = 'admin_email';
  static const _keyPassword = 'admin_password';
  static const _keyRemember = 'remember_me';

  static Future<void> saveLogin({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyRemember, value: rememberMe.toString());

    if (rememberMe) {
      await _storage.write(key: _keyPassword, value: password);
    } else {
      await _storage.delete(key: _keyPassword);
    }
  }

  static Future<String?> getEmail() =>
      _storage.read(key: _keyEmail);

  static Future<String?> getPassword() =>
      _storage.read(key: _keyPassword);

  static Future<bool> getRememberMe() async =>
      (await _storage.read(key: _keyRemember)) == 'true';

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
