import 'dart:convert';
import 'package:http/http.dart';

class ApiHelper {
  static dynamic handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw ApiException('Invalid response format', response.statusCode);
        }
      case 400:
        throw BadRequestException(
            _extractErrorMessage(response.body), response.statusCode);
      case 401:
        throw UnauthorizedException(
            _extractErrorMessage(response.body), response.statusCode);
      case 403:
        throw ForbiddenException(
            _extractErrorMessage(response.body), response.statusCode);
      case 404:
        throw NotFoundException(
            _extractErrorMessage(response.body), response.statusCode);
      case 500:
      default:
        throw ApiException(
            'Server error: ${response.statusCode}', response.statusCode);
    }
  }

  static String _extractErrorMessage(String responseBody) {
    try {
      final json = jsonDecode(responseBody);
      return json['message'] ?? json['error'] ?? responseBody;
    } catch (e) {
      return responseBody;
    }
  }
}

// Exceptions personnalisées
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class BadRequestException extends ApiException {
  BadRequestException(String message, int statusCode)
      : super(message, statusCode);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message, int statusCode)
      : super(message, statusCode);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message, int statusCode)
      : super(message, statusCode);
}

class NotFoundException extends ApiException {
  NotFoundException(String message, int statusCode)
      : super(message, statusCode);
}
