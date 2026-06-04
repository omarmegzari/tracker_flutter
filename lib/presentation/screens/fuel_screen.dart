import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/tracker_provider.dart';

class FuelScreen extends ConsumerWidget {
  const FuelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuelAsync = ref.watch(fuelEntriesProvider);
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      body: fuelAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('Aucun plein de carburant enregistré.'));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_gas_station, color: Colors.green),
                  title: Text('${entry.liters} Litres'),
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
                onPressed: () => _showAddFuelDialog(context, ref, vehicles),
                child: const Icon(Icons.add),
              ),
        orElse: () => null,
      ),
    );
  }

  void _showAddFuelDialog(BuildContext context, WidgetRef ref, List<dynamic> vehicles) {
    final litersController = TextEditingController();
    final costController = TextEditingController();
    String? selectedVehicleId = vehicles.first.id;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Nouveau plein de carburant'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedVehicleId,
                  items: vehicles.map((v) => DropdownMenuItem(value: v.id, child: Text('${v.brand} ${v.model}'))).toList(),
                  onChanged: (val) => setState(() => selectedVehicleId = val),
                  decoration: const InputDecoration(labelText: 'Véhicule'),
                ),
                TextField(controller: litersController, decoration: const InputDecoration(labelText: 'Litres (ex: 40)'), keyboardType: TextInputType.number),
                TextField(controller: costController, decoration: const InputDecoration(labelText: 'Coût total (MAD)'), keyboardType: TextInputType.number),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
              ElevatedButton(
                onPressed: () {
                  final liters = double.tryParse(litersController.text) ?? 0.0;
                  final cost = double.tryParse(costController.text) ?? 0.0;
                  if (selectedVehicleId != null && liters > 0 && cost > 0) {
                    ref.read(trackerControllerProvider.notifier).addFuelEntry(selectedVehicleId!, liters, cost);
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
