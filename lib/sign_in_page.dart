import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:totp_sample_app/routes.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _signInFormKey;
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _signInFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
              child: Form(
                key: _signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Sign In',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your password';
                        }

                        if ((value?.length ?? 0) < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
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
                        onPressed: _isSigningIn
                            ? null
                            : () async {
                                final isFormVilled =
                                    _signInFormKey.currentState?.validate() ??
                                        false;
                                if (isFormVilled) {
                                  final username = _usernameController.text;
                                  final password = _passwordController.text;
                                  try {
                                    setState(() {
                                      _isSigningIn = true;
                                    });
                                    await signInWithCognito(username, password);
                                  } on AuthException catch (e) {
                                    switch (e) {
                                      case UserNotFoundException _:
                                        _showSnackBar(
                                            'User not found. Sign up?');
                                        _usernameController.clear();
                                        _passwordController.clear();
                                        break;
                                      case InvalidPasswordException _:
                                        _showSnackBar(
                                          'Wrong password. Forgot password?',
                                        );
                                        _passwordController.clear();
                                        break;
                                      case LimitExceededException _:
                                        _showSnackBar(
                                          'Attempt limit exceeded, please try again later.',
                                        );
                                        break;
                                      default:
                                        safePrint('Sign in failed: $e');
                                        break;
                                    }
                                  } finally {
                                    setState(() {
                                      _isSigningIn = false;
                                    });
                                  }
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
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
                        onPressed: () {
                          context.go(Routes.signUp);
                        },
                        child: const Text('Don\'t have an account? Sign Up!'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithCognito(
    String username,
    String password,
  ) async {
    final result = await Amplify.Auth.signIn(
      username: username,
      password: password,
    );
    await _handleSignInResult(result);
  }

  Future<void> _handleSignInResult(SignInResult result) async {
    safePrint(result);
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.continueSignInWithMfaSelection:
      // Handle select from MFA methods case
      case AuthSignInStep.continueSignInWithTotpSetup:
        if (mounted) {
          final totpSetupDetails = result.nextStep.totpSetupDetails!;
          final setupUri = totpSetupDetails.getSetupUri(
            appName: 'TOTP_SAMPLE_APP',
          );
          context.go(
            Routes.setupTotp,
            extra: <String, String>{
              'username': _usernameController.text,
              'totp_uri': setupUri.toString(),
            },
          );
        }
      case AuthSignInStep.confirmSignInWithTotpMfaCode:
        context.go(
          Routes.verifyTotp,
          extra: _usernameController.text,
        );
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
      // Handle SMS MFA case
      case AuthSignInStep.confirmSignInWithNewPassword:
      // Handle new password case
      case AuthSignInStep.confirmSignInWithCustomChallenge:
      // Handle custom challenge case
      case AuthSignInStep.resetPassword:
      // Handle reset password case
      case AuthSignInStep.confirmSignUp:
        final resendResult = await Amplify.Auth.resendSignUpCode(
          username: _usernameController.text,
        );
        _showSnackBar(
          'Verification code sent to ${resendResult.codeDeliveryDetails.destination}',
        );
        if (mounted) {
          context.go(
            Routes.emailVerification,
            extra: _usernameController.text,
          );
        }
      case AuthSignInStep.done:
        if (mounted) {
          context.go(
            Routes.home,
            extra: _usernameController.text,
          );
        }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
