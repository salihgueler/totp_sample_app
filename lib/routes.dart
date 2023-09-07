import 'package:go_router/go_router.dart';
import 'package:totp_sample_app/home_page.dart';
import 'package:totp_sample_app/sign_in_page.dart';
import 'package:totp_sample_app/sign_up_page.dart';
import 'package:totp_sample_app/email_verification_page.dart';
import 'package:totp_sample_app/splash_page.dart';
import 'package:totp_sample_app/totp_setup_page.dart';
import 'package:totp_sample_app/totp_verification_page.dart';
import 'package:totp_sample_app/verification_successful_page.dart';

final routes = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SplashPage(),
      ),
    ),
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
      path: Routes.emailVerification,
      pageBuilder: (context, state) {
        final username = state.extra as String;
        return NoTransitionPage(
          child: EmailVerificationPage(
            username: username,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.verificationSuccessful,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: VerificationSuccessfulPage(),
      ),
    ),
    GoRoute(
      path: Routes.home,
      pageBuilder: (context, state) {
        final username = state.extra as String;
        return NoTransitionPage(
          child: HomePage(
            username: username,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.setupTotp,
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, String>;
        return NoTransitionPage(
          child: TotpSetupPage(
            username: data['username'] as String,
            totpUri: data['totp_uri'] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.verifyTotp,
      pageBuilder: (context, state) {
        final data = state.extra as String;
        return NoTransitionPage(
          child: TotpVerificationPage(
            username: data,
          ),
        );
      },
    ),
  ],
);

class Routes {
  Routes._();

  static const splash = '/';
  static const home = '/home';
  static const setupTotp = '/setup-totp';
  static const verifyTotp = '/verify-totp';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const emailVerification = '/email-verification';
  static const verificationSuccessful = '/verification-successful';
}
