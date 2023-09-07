// ignore_for_file: unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:totp_sample_app/routes.dart';
import 'package:totp_sample_app/verification_code_digit_view.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({
    required this.username,
    super.key,
  });

  final String username;
  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late final TextEditingController _digit1Controller;
  late final TextEditingController _digit2Controller;
  late final TextEditingController _digit3Controller;
  late final TextEditingController _digit4Controller;
  late final TextEditingController _digit5Controller;
  late final TextEditingController _digit6Controller;

  late final GlobalKey<FormState> _verificationFormKey;
  @override
  void initState() {
    super.initState();
    _digit1Controller = TextEditingController();
    _digit2Controller = TextEditingController();
    _digit3Controller = TextEditingController();
    _digit4Controller = TextEditingController();
    _digit5Controller = TextEditingController();
    _digit6Controller = TextEditingController();
    _verificationFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _digit1Controller.dispose();
    _digit2Controller.dispose();
    _digit3Controller.dispose();
    _digit4Controller.dispose();
    _digit5Controller.dispose();
    _digit6Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 480,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Two-Factor Verification',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Email Verification',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'To be able to sign-up you need to enter the verification code sent to your email address.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Verification Code',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _verificationFormKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: VerificationCodeDigitView(
                            controller: _digit1Controller,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: VerificationCodeDigitView(
                            controller: _digit2Controller,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: VerificationCodeDigitView(
                            controller: _digit3Controller,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: VerificationCodeDigitView(
                            controller: _digit4Controller,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: VerificationCodeDigitView(
                            controller: _digit5Controller,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: VerificationCodeDigitView(
                            controller: _digit6Controller,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(21, 29, 39, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final isFormValid =
                            _verificationFormKey.currentState?.validate() ??
                                false;
                        if (isFormValid) {
                          final confirmationCode = [
                            _digit1Controller.text,
                            _digit2Controller.text,
                            _digit3Controller.text,
                            _digit4Controller.text,
                            _digit5Controller.text,
                            _digit6Controller.text,
                          ].join();

                          // TODO: Call confirmSignUp function
                          context.go(Routes.verificationSuccessful);
                          _digit1Controller.clear();
                          _digit2Controller.clear();
                          _digit3Controller.clear();
                          _digit4Controller.clear();
                          _digit5Controller.clear();
                          _digit6Controller.clear();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Verify',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        // TODO: Call resendSignUpCode function
                      },
                      child: const Text('Resend Code'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
