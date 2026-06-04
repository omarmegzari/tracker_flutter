class MaintenanceCategory {
  final String id;
  final String name;

  MaintenanceCategory({
    required this.id,
    required this.name,
  });

  factory MaintenanceCategory.fromJson(Map<String, dynamic> json, String documentId) {
    return MaintenanceCategory(
      id: documentId,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
