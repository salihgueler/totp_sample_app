import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totp_sample_app/routes.dart';

class SignInFlowApplication extends StatelessWidget {
  const SignInFlowApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromRGBO(0, 180, 125, 1),
          onPrimary: Color.fromRGBO(77, 84, 92, 1),
          secondary: Color.fromRGBO(21, 29, 39, 1),
          onSecondary: Color.fromRGBO(21, 29, 39, 1),
          error: Colors.red,
          onError: Colors.redAccent,
          background: Color.fromRGBO(209, 211, 207, 1),
          onBackground: Color.fromRGBO(209, 211, 207, 1),
          surface: Color.fromRGBO(77, 84, 92, 1),
          onSurface: Color.fromRGBO(77, 84, 92, 1),
        ),
        textTheme: GoogleFonts.kanitTextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(77, 84, 92, 1)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: routes.routeInformationParser,
      routerDelegate: routes.routerDelegate,
      routeInformationProvider: routes.routeInformationProvider,
    );
  }
}
