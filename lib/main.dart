import 'package:flutter/material.dart';
import 'package:totp_sample_app/sign_in_flow_application.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  usePathUrlStrategy();
  // TODO: Call _configureAmplify
  runApp(
    const SignInFlowApplication(),
  );
}

/// TODO: Configure Amplify
