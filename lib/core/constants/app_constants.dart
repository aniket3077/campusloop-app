/// Constants used throughout the CampusLoop application
class AppConstants {
  static const String appName = 'CampusLoop';
  static const String appTagline = 'Circular Campus Resource Sharing';
  static const String appVersion = '1.0.0';

  // Specific Resource Categories required by CampusLoop Home Dashboard
  static const List<String> categories = [
    'All',
    'Books',
    'Calculators',
    'Drawing Kits',
    'Electronics',
    'Lab Components',
    'Project Materials',
    'Tools',
    'Other',
  ];

  // Quick Action Types
  static const String typeBuy = 'BUY';
  static const String typeSell = 'SELL';
  static const String typeBorrow = 'BORROW';
  static const String typeExchange = 'EXCHANGE';
  static const String typeDonate = 'DONATE';
  static const String typeRequest = 'REQUEST';

  static const List<String> resourceTypes = [
    'All Types',
    typeBuy,
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

  // Specific Campus Courses for Academic Resource Match
  static const List<String> courses = [
    'All Courses',
    'ME 101',
    'MATH 51',
    'ARCH 101',
    'EE 108',
    'CHEM 31A',
    'CS 106B',
    'PHYS 41',
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

  // Academic Years
  static const List<String> academicYears = [
    'Freshman (1st Year)',
    'Sophomore (2nd Year)',
    'Junior (3rd Year)',
    'Senior (4th Year)',
    'Graduate / Master\'s',
    'PhD / Doctorate',
  ];

  // Common Academic Departments
  static const List<String> departments = [
    'Computer Science & Engineering',
    'Electrical & Computer Engineering',
    'Mechanical Engineering',
    'Biological Sciences & Chemistry',
    'Business & Economics',
    'Physics & Mathematics',
    'Medicine & Health Sciences',
    'Humanities & Social Sciences',
    'Architecture & Design',
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
