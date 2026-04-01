import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/barcode_service.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;
  String? _scannedBarcode;
  BarcodeValidationResult? _validationResult;
  String? _productName;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (!_isScanning) return;

    final barcode = capture.barcodes.first.rawValue;
    if (barcode != null) {
      setState(() {
        _isScanning = false;
        _scannedBarcode = barcode;
        _validationResult = BarcodeService.validateBarcode(barcode);
        _productName = BarcodeService.getProductNameFromBarcode(barcode);
      });

      // Stop scanning after detection
      cameraController.stop();
    }
  }

  void _rescan() {
    setState(() {
      _isScanning = true;
      _scannedBarcode = null;
      _validationResult = null;
      _productName = null;
    });
    cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Barcode Scanner',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                MobileScanner(
                  controller: cameraController,
                  onDetect: _onBarcodeDetected,
                ),
                if (_isScanning)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 80.h,
                    ),
                    child: Center(
                      child: Text(
                        'Position barcode here',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Results Panel
          Container(
            height: 300.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan Result',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  if (_scannedBarcode != null) ...[
                    _buildResultItem(
                      icon: Icons.qr_code,
                      label: 'Barcode',
                      value: _scannedBarcode!,
                    ),
                    SizedBox(height: 12.h),
                    _buildResultItem(
                      icon: Icons.production_quantity_limits,
                      label: 'Product',
                      value: _productName!,
                    ),
                    SizedBox(height: 12.h),
                    _buildResultItem(
                      icon: _validationResult!.isValid ? Icons.check_circle : Icons.cancel,
                      label: 'Status',
                      value: _validationResult!.status,
                      valueColor: _validationResult!.isValid ? Colors.green : Colors.red,
                    ),
                    if (!_validationResult!.isValid)
                      Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          _validationResult!.message,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),

                    SizedBox(height: 20.h),
                    ElevatedButton.icon(
                      onPressed: _rescan,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(
                        'Scan Another',
                        style: GoogleFonts.poppins(),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 45.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 48.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Scan a barcode to see results',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.blue),
        SizedBox(width: 12.w),
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}