class Maintenance {
  final String id;
  final String vehicleId;
  final String categoryId;
  final DateTime date;
  final String description;
  final double cost;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.categoryId,
    required this.date,
    required this.description,
    required this.cost,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json, String documentId) {
    return Maintenance(
      id: documentId,
      vehicleId: json['vehicleId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
      cost: (json['cost'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'description': description,
      'cost': cost,
    };
  }
}
