import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../screens/login_screen.dart';
import '../screens/main_layout.dart';
import '../screens/dashboard_screen.dart';
import '../screens/vehicles_screen.dart';
import '../screens/fuel_screen.dart';
import '../screens/maintenance_screen.dart';
import '../../application/providers/auth_provider.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/vehicles',
            builder: (context, state) => const VehiclesScreen(),
          ),
          GoRoute(
            path: '/fuel',
            builder: (context, state) => const FuelScreen(),
          ),
          GoRoute(
            path: '/maintenance',
            builder: (context, state) => const MaintenanceScreen(),
          ),
        ],
      ),
    ],
  );
}
