import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:totp_sample_app/sign_in_flow_application.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  usePathUrlStrategy();
  await _configureAmplify();
  runApp(
    const SignInFlowApplication(),
  );
}

Future<void> _configureAmplify() async {
  try {
    Amplify.addPlugin(AmplifyAuthCognito());
    Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException catch (_) {
    safePrint('Amplify was already configured. Was the app restarted?');
  } on AmplifyException catch (e) {
    safePrint('Failed to configure Amplify: $e');
  }
}
