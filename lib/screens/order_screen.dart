import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../models/customer_type.dart';
import '../widgets/custom_button.dart';

class OrderScreen extends StatefulWidget {
  final Product product;
  final CustomerType customerType;

  const OrderScreen({
    super.key,
    required this.product,
    required this.customerType,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _quantityController = TextEditingController();
  String? _quantityError;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final quantity = int.tryParse(_quantityController.text);
    if (quantity != null && quantity > 0) {
      final price = widget.customerType == CustomerType.dealer
          ? widget.product.dealerPrice
          : widget.product.retailPrice;
      setState(() {
        _totalPrice = quantity * price;
      });
    } else {
      setState(() {
        _totalPrice = 0;
      });
    }
  }

  void _validateAndPlaceOrder() {
    final quantity = int.tryParse(_quantityController.text);

    if (quantity == null) {
      setState(() {
        _quantityError = 'Please enter a valid quantity';
      });
      return;
    }

    if (quantity < widget.product.moq) {
      setState(() {
        _quantityError = 'Minimum order quantity is ${widget.product.moq} units';
      });
      return;
    }

    // Order placed successfully
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 28.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Order Placed!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product: ${widget.product.name}',
              style: GoogleFonts.poppins(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Quantity: ${_quantityController.text}',
              style: GoogleFonts.poppins(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Total: ₹${_totalPrice.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPrice = widget.customerType == CustomerType.dealer
        ? widget.product.dealerPrice
        : widget.product.retailPrice;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Place Order',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Details',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildDetailRow('Product Name', widget.product.name),
                    _buildDetailRow('Customer Type', widget.customerType.displayName),
                    _buildDetailRow('Price per unit', '₹${currentPrice.toStringAsFixed(0)}'),
                    _buildDetailRow('Minimum Order Quantity', '${widget.product.moq} units'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Quantity Input
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Quantity',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter quantity',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        errorText: _quantityError,
                        errorStyle: GoogleFonts.poppins(fontSize: 12.sp),
                        prefixIcon: const Icon(Icons.shopping_cart),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Total Price Card
            if (_totalPrice > 0)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price:',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${_totalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20.h),

            // Place Order Button
            CustomButton(
              text: 'Place Order',
              onPressed: _validateAndPlaceOrder,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}