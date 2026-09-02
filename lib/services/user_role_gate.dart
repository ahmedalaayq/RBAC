import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rbac_app/models/user_model.dart';
import 'package:rbac_app/screens/dashboard/admin_dashboard.dart';
import 'package:rbac_app/screens/dashboard/user_dashboard.dart';
import 'package:rbac_app/screens/error_screen.dart';
import 'package:rbac_app/screens/signin_screen.dart';
import 'package:rbac_app/screens/splash_screen.dart';

class UserRoleGate extends StatelessWidget {
  const UserRoleGate({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasError) {
          return const ErrorScreen(
            message: 'Something went wrong loading user data.',
          );
        }

        final data = snapshot.data?.data();

        if (data == null) {
          return const SigninScreen();
        }

        final user = UserModel.fromJson(data);

        return switch (user.role) {
          UserRoleEnum.admin => const AdminDashboard(),
          UserRoleEnum.user => const UserDashboard(),
        };
      },
    );
  }
}
