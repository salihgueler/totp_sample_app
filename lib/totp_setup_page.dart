// ignore_for_file: unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:totp_sample_app/verification_code_digit_view.dart';

class TotpSetupPage extends StatefulWidget {
  const TotpSetupPage({
    required this.username,
    required this.totpUri,
    super.key,
  });

  final String username;
  final String totpUri;
  @override
  State<TotpSetupPage> createState() => _TotpSetupPageState();
}

class _TotpSetupPageState extends State<TotpSetupPage> {
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Time-based One-Time Password (TOTP) Setup',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.key,
                    color: Color.fromRGBO(0, 180, 125, 1),
                    size: 64,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Multi-factor Authentication',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'To be able to sign-in you need to scan this QR code with your Authenticator app and enter the verification code.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: QrImageView(
                      data: widget.totpUri,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Verification Code',
                    style: Theme.of(context).textTheme.titleSmall,
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
                        // TODO: Call confirmSignIn function
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
      ),
    );
  }
}
