class ImpactStatsModel {
  final double co2SavedKg;
  final int itemsReused;
  final double moneySavedUsd;
  final int treesSavedEquivalent;
  final int activeCampusBorrowers;

  const ImpactStatsModel({
    required this.co2SavedKg,
    required this.itemsReused,
    required this.moneySavedUsd,
    required this.treesSavedEquivalent,
    required this.activeCampusBorrowers,
  });

  factory ImpactStatsModel.fromJson(Map<String, dynamic> json) {
    return ImpactStatsModel(
      co2SavedKg: (json['co2SavedKg'] as num).toDouble(),
      itemsReused: json['itemsReused'] as int,
      moneySavedUsd: (json['moneySavedUsd'] as num).toDouble(),
      treesSavedEquivalent: json['treesSavedEquivalent'] as int,
      activeCampusBorrowers: json['activeCampusBorrowers'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'co2SavedKg': co2SavedKg,
      'itemsReused': itemsReused,
      'moneySavedUsd': moneySavedUsd,
      'treesSavedEquivalent': treesSavedEquivalent,
      'activeCampusBorrowers': activeCampusBorrowers,
    };
  }

  static const ImpactStatsModel mockCampusImpact = ImpactStatsModel(
    co2SavedKg: 1240.5,
    itemsReused: 486,
    moneySavedUsd: 14250.00,
    treesSavedEquivalent: 58,
    activeCampusBorrowers: 320,
  );
}
