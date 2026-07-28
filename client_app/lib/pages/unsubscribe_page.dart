import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';

class UnsubscribePage extends StatefulWidget {
  const UnsubscribePage({super.key});

  @override
  State<UnsubscribePage> createState() => _UnsubscribePageState();
}

class _UnsubscribePageState extends State<UnsubscribePage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Unsubscribe')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.unsubscribe, size: 72, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'Enter your mobile number to unsubscribe from BDApps notifications.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () {
                      final phone = _phoneController.text.trim();
                      if (phone.isNotEmpty) {
                        provider.unsubscribe(phone);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Unsubscribe',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 16),
                if (provider.errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.errorMessage,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                if (!provider.isLoading &&
                    provider.errorMessage.isEmpty &&
                    provider.hasCheckedStatus)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.isSubscribed
                          ? 'Your subscription status is still active.'
                          : 'You are not subscribed anymore.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green.shade800),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
