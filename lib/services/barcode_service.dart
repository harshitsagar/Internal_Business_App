class BarcodeService {
  // Rule: If barcode ends with even number → Valid, Odd → Invalid
  static BarcodeValidationResult validateBarcode(String barcode) {
    if (barcode.isEmpty) {
      return BarcodeValidationResult(
        isValid: false,
        message: 'Invalid barcode',
        status: '❌ Invalid',
      );
    }

    final lastChar = barcode[barcode.length - 1];
    final lastDigit = int.tryParse(lastChar);

    if (lastDigit == null) {
      return BarcodeValidationResult(
        isValid: false,
        message: 'Invalid barcode format',
        status: '❌ Invalid',
      );
    }

    final isValid = lastDigit % 2 == 0;

    return BarcodeValidationResult(
      isValid: isValid,
      message: isValid ? 'Barcode validated successfully' : 'Invalid barcode detected',
      status: isValid ? '✅ Valid' : '❌ Invalid',
    );
  }

  // Dummy mapping for product name based on barcode
  static String getProductNameFromBarcode(String barcode) {
    // Simple mapping for demo
    final Map<String, String> barcodeMapping = {
      '1234567890': 'Premium Laptop',
      '1234567891': 'Wireless Mouse',
      '1234567892': 'Mechanical Keyboard',
      '1234567893': '4K Monitor',
      '1234567894': 'USB-C Hub',
    };

    return barcodeMapping[barcode] ?? 'Unknown Product';
  }
}

class BarcodeValidationResult {
  final bool isValid;
  final String message;
  final String status;

  BarcodeValidationResult({
    required this.isValid,
    required this.message,
    required this.status,
  });
}