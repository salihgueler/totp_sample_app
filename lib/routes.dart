import 'package:go_router/go_router.dart';
import 'package:totp_sample_app/sign_in_page.dart';
import 'package:totp_sample_app/sign_up_page.dart';
import 'package:totp_sample_app/verification_page.dart';
import 'package:totp_sample_app/verification_successful_page.dart';

final routes = GoRouter(
  initialLocation: Routes.signIn,
  routes: [
    GoRoute(
      path: Routes.signIn,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SignInPage(),
      ),
    ),
    GoRoute(
      path: Routes.signUp,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SignUpPage(),
      ),
    ),
    GoRoute(
      path: Routes.verification,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: VerificationPage(),
      ),
    ),
    GoRoute(
      path: Routes.verificationSuccessful,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: VerificationSuccessfulPage(),
      ),
    ),
  ],
);

class Routes {
  Routes._();

  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const verification = '/verification';
  static const verificationSuccessful = '/verification-successful';
}
