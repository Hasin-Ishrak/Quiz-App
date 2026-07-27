import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BdAppsService {
  // Local Python (FastAPI) backend.
  // - Chrome / Windows desktop / any localhost target: 127.0.0.1
  // - Android emulator: use 10.0.2.2 instead of 127.0.0.1
  // - Physical device on same Wi-Fi: use your PC's LAN IP instead
  static const String _baseUrl = 'http://127.0.0.1:8001';
  late Dio _dio;

  BdAppsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }

  Future<Map<String, dynamic>> sendOtp(String mobileNumber) async {
    try {
      final response = await _dio.post(
        '/otp/send',
        data: {'user_mobile': mobileNumber},
      );
      return response.data;
    } catch (e) {
      debugPrint('Error sending OTP: $e');
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String referenceNo, String otp) async {
    try {
      final response = await _dio.post(
        '/otp/verify',
        data: {'referenceNo': referenceNo, 'otp': otp},
      );
      return response.data;
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<Map<String, dynamic>> checkSubscription(String mobileNumber) async {
    try {
      final response = await _dio.post(
        '/subscription/check',
        data: {'user_mobile': mobileNumber},
      );
      return response.data;
    } catch (e) {
      debugPrint('Error checking subscription: $e');
      throw Exception('Failed to check subscription: $e');
    }
  }

  Future<Map<String, dynamic>> unsubscribe(String mobileNumber) async {
    try {
      final response = await _dio.post(
        '/subscription/unsubscribe',
        data: {'user_mobile': mobileNumber},
      );
      return response.data;
    } catch (e) {
      debugPrint('Error unsubscribing: $e');
      throw Exception('Failed to unsubscribe: $e');
    }
  }
}