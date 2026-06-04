import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/tracker_provider.dart';
import '../../domain/models/vehicle.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceAsync = ref.watch(maintenancesProvider);
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      body: maintenanceAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('Aucune maintenance enregistrée.'));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.build, color: Colors.orange),
                  title: Text(entry.description),
                  subtitle: Text('Coût: ${entry.cost} MAD'),
                  trailing: Text(entry.date.toString().substring(0, 10)),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
      ),
      floatingActionButton: vehiclesAsync.maybeWhen(
        data: (vehicles) => vehicles.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () => _showAddMaintenanceDialog(context, ref, vehicles),
                child: const Icon(Icons.add),
              ),
        orElse: () => null,
      ),
    );
  }

  void _showAddMaintenanceDialog(BuildContext context, WidgetRef ref, List<Vehicle> vehicles) {
    final descController = TextEditingController();
    final costController = TextEditingController();
    String? selectedVehicleId = vehicles.first.id;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Nouvelle opération de maintenance'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedVehicleId,
                  items: vehicles.map((v) => DropdownMenuItem<String>(value: v.id, child: Text('${v.brand} ${v.model}'))).toList(),
                  onChanged: (val) => setState(() => selectedVehicleId = val),
                  decoration: const InputDecoration(labelText: 'Véhicule'),
                ),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description (ex: Vidange)')),
                TextField(controller: costController, decoration: const InputDecoration(labelText: 'Coût total (MAD)'), keyboardType: TextInputType.number),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
              ElevatedButton(
                onPressed: () {
                  final cost = double.tryParse(costController.text) ?? 0.0;
                  final desc = descController.text.trim();
                  if (selectedVehicleId != null && desc.isNotEmpty && cost > 0) {
                    ref.read(trackerControllerProvider.notifier).addMaintenance(selectedVehicleId!, desc, cost);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        );
      },
    );
  }
}
