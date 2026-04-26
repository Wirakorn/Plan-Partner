import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  static const String _profileKey = 'plan_partner_profile';
  static const String _savedUsernameKey = 'auth_username';
  final _uuid = const Uuid();
  User? _user;

  fb_auth.FirebaseAuth? get _auth {
    try {
      return fb_auth.FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  User? get user => _user;
  String? get firebaseUid => _auth?.currentUser?.uid;
  bool get isAuthenticated => _auth?.currentUser != null;

  UserProvider() {
    _user = User(id: _uuid.v4(), name: 'Planner');
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_profileKey);
      final savedUsername = prefs.getString(_savedUsernameKey)?.trim();
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          _user = User.fromJson(decoded);
        } else if (decoded is Map) {
          _user = User.fromJson(decoded.cast<String, dynamic>());
        }
        if (savedUsername != null && savedUsername.isNotEmpty) {
          final currentName = _user?.name.trim() ?? '';
          if (currentName.isEmpty || currentName == 'Planner') {
            _user = User(id: _user?.id ?? _uuid.v4(), name: savedUsername);
            await _saveUser();
          }
        }
      } else {
        if (savedUsername != null && savedUsername.trim().isNotEmpty) {
          _user = User(id: _uuid.v4(), name: savedUsername);
          await _saveUser();
        } else {
          await _saveUser();
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_user == null) return;
      await prefs.setString(_profileKey, jsonEncode(_user!.toJson()));
      await prefs.setString(_savedUsernameKey, _user!.name);
    } catch (_) {}
  }

  Future<void> createDefaultUser(String name) async {
    _user = User(id: _user?.id ?? _uuid.v4(), name: name);
    await _saveUser();
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    _user = User(id: _user?.id ?? _uuid.v4(), name: name);
    await _saveUser();
    notifyListeners();
  }

  Future<void> resetProfile() async {
    _user = User(id: _uuid.v4(), name: 'Planner');
    await _saveUser();
    notifyListeners();
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final auth = _auth;
      if (auth == null) throw Exception('Firebase not initialized');

      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        _user = User(id: cred.user!.uid, name: cred.user!.email ?? 'User');
        await _saveUser();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final auth = _auth;
      if (auth == null) throw Exception('Firebase not initialized');

      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        _user = User(id: cred.user!.uid, name: name);
        await _saveUser();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      final auth = _auth;
      if (auth == null) throw Exception('Firebase not initialized');

      await auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
