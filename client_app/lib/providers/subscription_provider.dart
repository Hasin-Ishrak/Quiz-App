import 'package:flutter/material.dart';
import '../services/bdapps_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionState { inputPhone, inputOtp, subscribed, error }

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionProvider({
    BdAppsService? bdAppsService,
    Future<SharedPreferences> Function()? sharedPreferencesProvider,
  }) : _bdAppsService = bdAppsService ?? BdAppsService(),
       _sharedPreferencesProvider =
           sharedPreferencesProvider ?? SharedPreferences.getInstance {
    _loadSubscriptionStatus();
  }

  final BdAppsService _bdAppsService;
  final Future<SharedPreferences> Function() _sharedPreferencesProvider;

  SubscriptionState _state = SubscriptionState.inputPhone;
  SubscriptionState get state => _state;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _referenceNo = '';
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  bool _hasCheckedStatus = false;
  bool get hasCheckedStatus => _hasCheckedStatus;

  Future<void> _loadSubscriptionStatus() async {
    final prefs = await _sharedPreferencesProvider();
    _isSubscribed = prefs.getBool('isSubscribed') ?? false;
    _phoneNumber = prefs.getString('phoneNumber') ?? '';

    if (_phoneNumber.isNotEmpty) {
      await checkSubscriptionStatus();
    } else if (_isSubscribed) {
      _state = SubscriptionState.subscribed;
      notifyListeners();
    } else {
      _state = SubscriptionState.inputPhone;
      notifyListeners();
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    _setLoading(true);
    _phoneNumber = phoneNumber;
    try {
      final response = await _bdAppsService.sendOtp(phoneNumber);
      final prefs = await _sharedPreferencesProvider();
      await prefs.setString('phoneNumber', phoneNumber);
      if (response['success'] == true && response['referenceNo'] != null) {
        _referenceNo = response['referenceNo'];
        _state = SubscriptionState.inputOtp;
        _errorMessage = '';
      } else {
        _state = SubscriptionState.error;
        _errorMessage = response['message'] ?? 'Failed to send OTP';
      }
    } catch (e) {
      _state = SubscriptionState.error;
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp(String otp) async {
    _setLoading(true);
    try {
      final response = await _bdAppsService.verifyOtp(_referenceNo, otp);
      if (response['statusCode'] == 'S1000' ||
          response['subscriptionStatus'] == 'REGISTERED') {
        _state = SubscriptionState.subscribed;
        _isSubscribed = true;
        _errorMessage = '';

        final prefs = await _sharedPreferencesProvider();
        await prefs.setBool('isSubscribed', true);
        await prefs.setString('phoneNumber', _phoneNumber);
        await prefs.setString('subscriberId', response['subscriberId'] ?? '');
      } else {
        _errorMessage = response['statusDetail'] ?? 'Failed to verify OTP';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkSubscriptionStatus([String? phoneNumber]) async {
    final value = (phoneNumber ?? _phoneNumber).trim();
    if (value.isEmpty) return;

    _phoneNumber = value;
    _setLoading(true);
    try {
      final response = await _bdAppsService.checkSubscription(value);
      _hasCheckedStatus = true;
      if (response['isSubscribed'] == true) {
        _state = SubscriptionState.subscribed;
        _isSubscribed = true;

        final prefs = await _sharedPreferencesProvider();
        await prefs.setBool('isSubscribed', true);
      } else {
        _isSubscribed = false;
        _state = SubscriptionState.inputPhone;
        final prefs = await _sharedPreferencesProvider();
        await prefs.setBool('isSubscribed', false);
      }
      _errorMessage = '';
    } catch (e) {
      _hasCheckedStatus = true;
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> unsubscribe(String phoneNumber) async {
    _setLoading(true);
    _phoneNumber = phoneNumber;
    try {
      final response = await _bdAppsService.unsubscribe(phoneNumber);
      _hasCheckedStatus = true;
      if (response['success'] == true || response['statusCode'] == 'S1000') {
        _state = SubscriptionState.inputPhone;
        _isSubscribed = false;
        _errorMessage = '';

        final prefs = await _sharedPreferencesProvider();
        await prefs.setBool('isSubscribed', false);
        await prefs.setString('phoneNumber', phoneNumber);
        await prefs.remove('subscriberId');
      } else {
        _errorMessage =
            response['statusDetail'] ??
            response['error'] ??
            'Failed to unsubscribe';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void reset() {
    _state = SubscriptionState.inputPhone;
    _errorMessage = '';
    _hasCheckedStatus = false;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
