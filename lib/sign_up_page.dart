import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:totp_sample_app/routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _signUpFormKey;
  bool _isSigningUp = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _signUpFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
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
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Sign Up',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      controller: _usernameController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!value!.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your password';
                        }
                        if (value!.length < 8) {
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
                        onPressed: _isSigningUp
                            ? null
                            : () async {
                                final isSignUpFormValid =
                                    _signUpFormKey.currentState?.validate() ??
                                        false;
                                if (isSignUpFormValid) {
                                  final username = _usernameController.text;
                                  final email = _emailController.text;
                                  final password = _passwordController.text;

                                  try {
                                    setState(() {
                                      _isSigningUp = true;
                                    });
                                    await signUpUser(
                                      username: username,
                                      password: password,
                                      email: email,
                                    );
                                    if (mounted) {
                                      context.go(
                                        Routes.emailVerification,
                                        extra: username,
                                      );
                                    }
                                  } on AuthException catch (e) {
                                    switch (e) {
                                      case UsernameExistsException _:
                                        _showSnackBar(
                                            'Username already exists');
                                        _usernameController.clear();
                                        break;
                                      case InvalidPasswordException _:
                                        _showSnackBar(
                                            'Invalid password format');
                                        _passwordController.clear();
                                        break;
                                      default:
                                        _showSnackBar('Sign up failed. $e');
                                        break;
                                    }
                                  } finally {
                                    setState(() {
                                      _isSigningUp = false;
                                    });
                                  }
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Sign Up',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUpUser({
    required String username,
    required String password,
    required String email,
  }) async {
    final userAttributes = {
      AuthUserAttributeKey.email: email,
    };
    final result = await Amplify.Auth.signUp(
      username: username,
      password: password,
      options: SignUpOptions(
        userAttributes: userAttributes,
      ),
    );
    await _handleSignUpResult(result);
  }

  Future<void> _handleSignUpResult(SignUpResult result) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        _handleCodeDelivery(result.nextStep.codeDeliveryDetails);
        break;
      case AuthSignUpStep.done:
        _showSnackBar('Sign up is complete');
        break;
    }
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails? codeDeliveryDetails) {
    _showSnackBar(
      'A confirmation code has been sent to ${codeDeliveryDetails?.destination}. '
      'Please check your ${codeDeliveryDetails?.deliveryMedium.name} for the code.',
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
