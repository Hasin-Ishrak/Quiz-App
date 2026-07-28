import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../app_route.dart';
import 'package:go_router/go_router.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SubscriptionProvider>();
      if (provider.phoneNumber.isNotEmpty &&
          !provider.hasCheckedStatus &&
          !provider.isLoading) {
        provider.checkSubscriptionStatus();
      }
      if (provider.phoneNumber.isNotEmpty) {
        _phoneController.text = provider.phoneNumber;
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Subscribe')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: _buildBody(provider)),
      ),
    );
  }

  Widget _buildBody(SubscriptionProvider provider) {
    if (provider.isLoading) {
      return const CircularProgressIndicator();
    }

    if (provider.state == SubscriptionState.subscribed) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 16),
          const Text(
            'You are subscribed!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.go(AppRoute.home);
            },
            child: const Text('Go to Home'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.push(AppRoute.unsubscribe),
            child: const Text('Unsubscribe'),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (provider.errorMessage.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 24),
            color: Colors.red.shade100,
            child: Text(
              provider.errorMessage,
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
        if (provider.state == SubscriptionState.inputPhone ||
            provider.state == SubscriptionState.error) ...[
          const Text(
            'Enter your mobile number to subscribe or check status',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (provider.hasCheckedStatus)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: provider.isSubscribed
                    ? Colors.green.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                provider.isSubscribed
                    ? 'Current status: subscribed'
                    : 'Current status: not subscribed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: provider.isSubscribed
                      ? Colors.green.shade800
                      : Colors.orange.shade800,
                ),
              ),
            ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              hintText: '018XXXXXXXX',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final phone = _phoneController.text.trim();
              if (phone.isNotEmpty) {
                provider.sendOtp(phone);
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Send OTP', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final phone = _phoneController.text.trim();
                    if (phone.isNotEmpty) {
                      provider.checkSubscriptionStatus(phone);
                    }
                  },
                  child: const Text('Check Status'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(AppRoute.unsubscribe),
                  child: const Text('Unsubscribe'),
                ),
              ),
            ],
          ),
        ],
        if (provider.state == SubscriptionState.inputOtp) ...[
          const Text(
            'Enter the OTP sent to your phone',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _otpController,
            decoration: const InputDecoration(
              labelText: 'OTP',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_otpController.text.isNotEmpty) {
                provider.verifyOtp(_otpController.text);
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Verify & Subscribe', style: TextStyle(fontSize: 16)),
            ),
          ),
          TextButton(
            onPressed: () => provider.reset(),
            child: const Text('Change Phone Number'),
          ),
        ],
      ],
    );
  }
}
