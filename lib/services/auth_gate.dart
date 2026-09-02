import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rbac_app/screens/splash_screen.dart';

import '../screens/error_screen.dart';
import '../screens/signin_screen.dart';
import 'user_role_gate.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == .waiting) {
          return const SplashScreen();
        }

        if (authSnapshot.hasError) {
          return ErrorScreen(
            message:
                'Something went wrong with authentication. ${authSnapshot.error.toString()}',
          );
        }

        final User? firebaseUser = authSnapshot.data;

        if (firebaseUser == null) {
          return const SigninScreen();
        }

        return UserRoleGate(userId: firebaseUser.uid);
      },
    );
  }
}
