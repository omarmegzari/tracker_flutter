import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_provider.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    
    int currentIndex = 0;
    if (location.startsWith('/dashboard')) currentIndex = 0;
    if (location.startsWith('/vehicles')) currentIndex = 1;
    if (location.startsWith('/fuel')) currentIndex = 2;
    if (location.startsWith('/maintenance')) currentIndex = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker Chauffeur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          )
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/vehicles');
              break;
            case 2:
              context.go('/fuel');
              break;
            case 3:
              context.go('/maintenance');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Véhicules'),
          BottomNavigationBarItem(icon: Icon(Icons.local_gas_station), label: 'Carburant'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Maintenance'),
        ],
      ),
    );
  }
}
