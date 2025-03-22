class PaymentValidators {
  static bool isValidCardNumber(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    if (cleanNumber.length != 16) return false;
    return RegExp(r'^[0-9]{16}$').hasMatch(cleanNumber);
  }

  static bool isValidExpiryDate(String date) {
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(date)) return false;
    
    final parts = date.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    
    final now = DateTime.now();
    final cardDate = DateTime(year, month);
    
    return cardDate.isAfter(now);
  }

  static bool isValidCVV(String cvv) {
    return RegExp(r'^[0-9]{3,4}$').hasMatch(cvv);
  }
}
