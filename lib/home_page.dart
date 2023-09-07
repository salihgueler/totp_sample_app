import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:totp_sample_app/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.username,
    super.key,
  });

  final String username;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    'Home Page',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.home_work,
                    color: Color.fromRGBO(0, 180, 125, 1),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome ${widget.username}! \nThis is your home page after you sign in.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(21, 29, 39, 1),
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
                        try {
                          await Amplify.Auth.signOut();
                          if (mounted) {
                            context.go(Routes.signIn);
                          }
                        } on AuthException catch (e) {
                          _showSnackBar('Error signing out - ${e.message}');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Sign out',
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
