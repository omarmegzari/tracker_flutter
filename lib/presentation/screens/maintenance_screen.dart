import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/tracker_provider.dart';
import '../../domain/models/vehicle.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  String? _selectedFilterVehicleId;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final maintenanceAsync = ref.watch(maintenancesProvider);
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      body: vehiclesAsync.when(
        data: (vehicles) {
          return Column(
            children: [
              // Barre de filtres
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFilterVehicleId,
                        hint: const Text('Tous les véhicules'),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Tous les véhicules')),
                          ...vehicles.map((v) => DropdownMenuItem<String>(value: v.id, child: Text('${v.brand} ${v.model}'))),
                        ],
                        onChanged: (val) => setState(() => _selectedFilterVehicleId = val),
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.date_range, color: Colors.blue),
                      tooltip: 'Filtrer par date',
                      onPressed: () async {
                        final range = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialDateRange: _selectedDateRange,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light(),
                              child: child!,
                            );
                          },
                        );
                        if (range != null) {
                          setState(() => _selectedDateRange = range);
                        }
                      },
                    ),
                    if (_selectedDateRange != null || _selectedFilterVehicleId != null)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        tooltip: 'Effacer les filtres',
                        onPressed: () => setState(() {
                          _selectedDateRange = null;
                          _selectedFilterVehicleId = null;
                        }),
                      ),
                  ],
                ),
              ),
              if (_selectedDateRange != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Période: du ${_selectedDateRange!.start.toString().substring(0,10)} au ${_selectedDateRange!.end.toString().substring(0,10)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              
              // Liste filtrée
              Expanded(
                child: maintenanceAsync.when(
                  data: (entries) {
                    var filteredEntries = entries;
                    
                    if (_selectedFilterVehicleId != null) {
                      filteredEntries = filteredEntries.where((e) => e.vehicleId == _selectedFilterVehicleId).toList();
                    }
                    
                    if (_selectedDateRange != null) {
                      filteredEntries = filteredEntries.where((e) {
                        return e.date.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) && 
                               e.date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
                      }).toList();
                    }

                    if (filteredEntries.isEmpty) {
                      return const Center(child: Text('Aucun historique trouvé pour ces filtres.'));
                    }
                    
                    return ListView.builder(
                      itemCount: filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = filteredEntries[index];
                        final vehicle = vehicles.firstWhere(
                          (v) => v.id == entry.vehicleId, 
                          orElse: () => Vehicle(id: '', brand: 'Inconnu', model: '', registrationNumber: '')
                        );
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.build, color: Colors.orange),
                            title: Text(entry.description),
                            subtitle: Text('${vehicle.brand} ${vehicle.model}\nCoût: ${entry.cost} MAD'),
                            isThreeLine: true,
                            trailing: Text(entry.date.toString().substring(0, 10)),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Erreur : $err')),
                ),
              ),
            ],
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
