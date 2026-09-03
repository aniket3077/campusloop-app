class Validators {
  static String? validateCollegeEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your university email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+edu$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please use a valid .edu college email address';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? validatePrice(String? value, bool isFreeAllowed) {
    if (isFreeAllowed && (value == null || value.trim().isEmpty)) {
      return null;
    }
    if (value == null || value.trim().isEmpty) {
      return 'Please enter price';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid numeric price';
    }
    if (price < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }
}
