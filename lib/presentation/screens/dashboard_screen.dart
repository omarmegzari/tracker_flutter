import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/tracker_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuelAsync = ref.watch(fuelEntriesProvider);
    final maintenanceAsync = ref.watch(maintenancesProvider);
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const Center(child: Text("Bienvenue ! Commencez par ajouter un véhicule dans l'onglet Véhicules."));
          }

          final fuelEntries = fuelAsync.value ?? [];
          final maintenances = maintenanceAsync.value ?? [];

          double totalFuelCost = fuelEntries.fold(0, (sum, entry) => sum + entry.cost);
          double totalMaintenanceCost = maintenances.fold(0, (sum, entry) => sum + entry.cost);
          double totalCost = totalFuelCost + totalMaintenanceCost;

          double fuelPercentage = totalCost == 0 ? 0 : (totalFuelCost / totalCost) * 100;
          double maintenancePercentage = totalCost == 0 ? 0 : (totalMaintenanceCost / totalCost) * 100;

          // Calcul Consommation ce mois
          final now = DateTime.now();
          final currentMonthEntries = fuelEntries.where((e) => e.date.year == now.year && e.date.month == now.month).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 4,
                color: Colors.blueGrey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Dépenses Globales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text('${totalCost.toStringAsFixed(2)} MAD', style: const TextStyle(fontSize: 32, color: Colors.blueGrey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.local_gas_station, color: Colors.green, size: 40),
                            const SizedBox(height: 8),
                            Text('Carburant\n${fuelPercentage.toStringAsFixed(1)}%', textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Text('${totalFuelCost.toStringAsFixed(2)} MAD', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.build, color: Colors.orange, size: 40),
                            const SizedBox(height: 8),
                            Text('Maintenance\n${maintenancePercentage.toStringAsFixed(1)}%', textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Text('${totalMaintenanceCost.toStringAsFixed(2)} MAD', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Consommation de ce mois', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...vehicles.map((vehicle) {
                final vehicleEntries = currentMonthEntries.where((e) => e.vehicleId == vehicle.id).toList();
                final liters = vehicleEntries.fold(0.0, (sum, e) => sum + e.liters);
                final cost = vehicleEntries.fold(0.0, (sum, e) => sum + e.cost);
                
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.directions_car, color: Colors.blue),
                    title: Text('${vehicle.brand} ${vehicle.model}'),
                    subtitle: Text('${liters.toStringAsFixed(1)} Litres consumés ce mois-ci'),
                    trailing: Text('${cost.toStringAsFixed(2)} MAD', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
