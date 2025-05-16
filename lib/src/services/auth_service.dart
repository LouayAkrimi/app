import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService {
  // Configuration des URLs
  static const String _baseUrl =
      'http://10.0.2.2:3000/api'; // Pour émulateur Android
  static const Duration _timeoutDuration = Duration(seconds: 10);

  // Méthode d'inscription
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'role': role,
            }),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      debugPrint('Erreur ClientException: $e');
      return _buildErrorResponse('Erreur de connexion au serveur');
    } on TimeoutException {
      return _buildErrorResponse('Le serveur met trop de temps à répondre');
    } catch (e) {
      debugPrint('Erreur inattendue: $e');
      return _buildErrorResponse('Erreur inattendue');
    }
  }

  // Méthode de connexion
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      debugPrint('Erreur ClientException: $e');
      return _buildErrorResponse('Erreur de connexion au serveur');
    } on TimeoutException {
      return _buildErrorResponse('Le serveur met trop de temps à répondre');
    } catch (e) {
      debugPrint('Erreur inattendue: $e');
      return _buildErrorResponse('Erreur inattendue');
    }
  }

  // Gestion des réponses
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        return _buildErrorResponse(
          data['message'] ?? 'Erreur inconnue',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('Erreur de parsing JSON: $e');
      return _buildErrorResponse('Format de réponse invalide');
    }
  }

  // Construction des réponses d'erreur
  static Map<String, dynamic> _buildErrorResponse(String message,
      {int? statusCode}) {
    return {
      'success': false,
      'message': message,
      if (statusCode != null) 'statusCode': statusCode,
    };
  }

  // Méthode pour vérifier la connexion au serveur
  static Future<bool> checkServerConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/test'),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
