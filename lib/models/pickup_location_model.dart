class PickupLocationModel {
  final String id;
  final String name;
  final String building;
  final String description;
  final String operatingHours;
  final String safetyTips;
  final bool isDefault;

  const PickupLocationModel({
    required this.id,
    required this.name,
    required this.building,
    required this.description,
    required this.operatingHours,
    required this.safetyTips,
    this.isDefault = false,
  });

  factory PickupLocationModel.fromJson(Map<String, dynamic> json) {
    return PickupLocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      building: json['building'] as String,
      description: json['description'] as String,
      operatingHours: json['operatingHours'] as String,
      safetyTips: json['safetyTips'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'building': building,
      'description': description,
      'operatingHours': operatingHours,
      'safetyTips': safetyTips,
      'isDefault': isDefault,
    };
  }

  static List<PickupLocationModel> get adminConfiguredLocations => const [
    PickupLocationModel(
      id: 'loc_001',
      name: 'Main Gate',
      building: 'Campus Main Entrance',
      description: 'Right beside the Security Information Desk at the Main Campus Gate.',
      operatingHours: '24/7 (Recommended: 8 AM - 8 PM)',
      safetyTips: 'Well-lit area under campus security supervision.',
      isDefault: true,
    ),
    PickupLocationModel(
      id: 'loc_002',
      name: 'Library Lounge',
      building: 'Main University Library',
      description: '1st Floor Student Study Lounge near the Central Information Desk.',
      operatingHours: '7:30 AM - 11:00 PM',
      safetyTips: 'Quiet, high-foot-traffic area with indoor seating.',
    ),
    PickupLocationModel(
      id: 'loc_003',
      name: 'Engineering Block',
      building: 'Packard Engineering Quad',
      description: 'Outdoor benches near the Packard Quad Fountain & Cafeteria.',
      operatingHours: '8:00 AM - 7:00 PM',
      safetyTips: 'Popular meeting spot for CS, EE & Mechanical engineering students.',
    ),
    PickupLocationModel(
      id: 'loc_004',
      name: 'Student Center',
      building: 'Tressider Student Union',
      description: 'Main Concourse Atrium near the Student Services Desk.',
      operatingHours: '8:00 AM - 10:00 PM',
      safetyTips: 'Central hub with security cameras and dining seating.',
    ),
  ];
}
