class FuelEntry {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double liters;
  final double cost;

  FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.cost,
  });

  factory FuelEntry.fromJson(Map<String, dynamic> json, String documentId) {
    return FuelEntry(
      id: documentId,
      vehicleId: json['vehicleId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      liters: (json['liters'] ?? 0.0).toDouble(),
      cost: (json['cost'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'date': date.toIso8601String(),
      'liters': liters,
      'cost': cost,
    };
  }
}
