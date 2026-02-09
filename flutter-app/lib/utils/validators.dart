/// Validation utilities for Blood Near Me app

/// Validates Indian mobile phone numbers
/// Format: 10 digits, starting with 6-9
/// Examples: 9876543210, 8123456789, 7012345678, 6987654321
class PhoneValidator {
  static final RegExp _indianMobileRegex = RegExp(r'^[6-9]\d{9}$');

  /// Validates if a phone number is a valid Indian mobile number
  /// Returns true if valid, false otherwise
  static bool isValid(String phone) {
    // Remove any spaces, dashes, or parentheses
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    // Check if it matches Indian mobile format
    return _indianMobileRegex.hasMatch(cleanPhone);
  }

  /// Returns a formatted error message if phone is invalid
  /// Returns null if phone is valid
  static String? validate(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }

    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (cleanPhone.length < 10) {
      return 'Phone number must be 10 digits';
    }

    if (cleanPhone.length > 10) {
      return 'Phone number must be exactly 10 digits';
    }

    if (!cleanPhone.startsWith(RegExp(r'[6-9]'))) {
      return 'Phone number must start with 6, 7, 8, or 9';
    }

    if (!_indianMobileRegex.hasMatch(cleanPhone)) {
      return 'Please enter a valid Indian mobile number';
    }

    return null; // Valid
  }

  /// Formats a phone number for display
  /// Example: 9876543210 → +91 98765 43210
  static String format(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.length == 10) {
      return '+91 ${cleanPhone.substring(0, 5)} ${cleanPhone.substring(5)}';
    }
    return phone;
  }

  /// Cleans a phone number (removes formatting)
  /// Example: +91 98765 43210 → 9876543210
  static String clean(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
  }
}
