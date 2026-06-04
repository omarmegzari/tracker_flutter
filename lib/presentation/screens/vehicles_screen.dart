import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/tracker_provider.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      body: vehiclesAsync.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const Center(child: Text('Aucun véhicule enregistré.'));
          }
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.directions_car, color: Colors.blue),
                  title: Text('${vehicle.brand} ${vehicle.model}'),
                  subtitle: Text('Immatriculation : ${vehicle.registrationNumber}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVehicleDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context, WidgetRef ref) {
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final regController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un véhicule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Marque (ex: Renault)')),
            TextField(controller: modelController, decoration: const InputDecoration(labelText: 'Modèle (ex: Kangoo)')),
            TextField(controller: regController, decoration: const InputDecoration(labelText: 'Immatriculation')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (brandController.text.isNotEmpty && modelController.text.isNotEmpty && regController.text.isNotEmpty) {
                ref.read(trackerControllerProvider.notifier).addVehicle(
                  brandController.text,
                  modelController.text,
                  regController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
