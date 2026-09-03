/// Constants used throughout the CampusLoop application
class AppConstants {
  static const String appName = 'CampusLoop';
  static const String appTagline = 'Circular Campus Resource Sharing';
  static const String appVersion = '1.0.0';

  // Resource Categories
  static const List<String> categories = [
    'All Categories',
    'Textbooks & Reading',
    'Lab Equipment & Kits',
    'Class Notes & Summaries',
    'Electronics & Calculators',
    'Drafting & Art Supplies',
    'Dorm & Study Essentials',
  ];

  // Resource Types
  static const String typeBuy = 'BUY';
  static const String typeSell = 'SELL';
  static const String typeBorrow = 'BORROW';
  static const String typeExchange = 'EXCHANGE';
  static const String typeDonate = 'DONATE';
  static const String typeRequest = 'REQUEST';

  static const List<String> resourceTypes = [
    'All Types',
    typeSell,
    typeBorrow,
    typeExchange,
    typeDonate,
    typeRequest,
  ];

  // Item Conditions
  static const List<String> itemConditions = [
    'Like New',
    'Good',
    'Fair',
    'Heavily Used / Annotated',
  ];

  // Sample Universities
  static const List<String> universities = [
    'Stanford University',
    'Massachusetts Institute of Technology (MIT)',
    'UC Berkeley',
    'Harvard University',
    'UT Austin',
    'University of Washington',
  ];

  // Sample Pickup Locations
  static const List<String> campusPickupSpots = [
    'Main Library Student Lounge',
    'Student Union Center',
    'Engineering Quad Bench A',
    'Science & Tech Quad Cafeteria',
    'Campus North Dining Hall',
  ];
}
