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
      name: 'MIT CSN Main Gate Security Post',
      building: 'MIT CSN Main Entrance Arch',
      description: 'Right beside the Security Information Desk at the Main Gate on Beed Bypass Road.',
      operatingHours: '24/7 (Recommended: 8:00 AM - 8:30 PM)',
      safetyTips: 'Under 24/7 CCTV surveillance and security guard attendance.',
      isDefault: true,
    ),
    PickupLocationModel(
      id: 'loc_002',
      name: 'MIT CSN Central Library Ground Floor',
      building: 'Central Knowledge & Library Building',
      description: 'Reference section circulation lobby near the digital catalog terminal.',
      operatingHours: '8:00 AM - 10:00 PM',
      safetyTips: 'Quiet, high-visibility academic space with dedicated indoor seating.',
    ),
    PickupLocationModel(
      id: 'loc_003',
      name: 'Computer Science & Engineering Block Atrium',
      building: 'Department of CSE & IT Quad',
      description: 'Central open-air atrium near Lab 4 and the department bulletin board.',
      operatingHours: '8:00 AM - 7:00 PM',
      safetyTips: 'Active engineering student hub with campus Wi-Fi coverage.',
    ),
    PickupLocationModel(
      id: 'loc_004',
      name: 'Campus Cafeteria Student Hub',
      building: 'Student Amenities & Dining Complex',
      description: 'Designated CampusLoop circular table near the cafeteria entrance.',
      operatingHours: '8:30 AM - 9:00 PM',
      safetyTips: 'Well-lit dining plaza with high student foot traffic.',
    ),
  ];
}
