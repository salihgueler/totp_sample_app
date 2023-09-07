import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:totp_sample_app/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<(String, bool)>(
        future: _checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data!;
            if (result.$2) {
              context.go(Routes.home, extra: result.$1);
            } else {
              context.go(Routes.signIn);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<(String, bool)> _checkAuthStatus() async {
    final isSignedIn = await Amplify.Auth.fetchAuthSession();
    if (isSignedIn.isSignedIn) {
      final username = (await Amplify.Auth.getCurrentUser()).username;
      return (username, true);
    } else {
      return ('', false);
    }
  }
}
