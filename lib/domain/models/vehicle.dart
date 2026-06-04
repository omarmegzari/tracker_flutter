class Vehicle {
  final String id;
  final String brand;
  final String model;
  final String registrationNumber; // Immatriculation

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.registrationNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json, String documentId) {
    return Vehicle(
      id: documentId,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'registrationNumber': registrationNumber,
    };
  }
}
