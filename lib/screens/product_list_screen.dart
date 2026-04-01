import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_app_demo/screens/barcode_scanner_screen.dart';
import 'package:internal_app_demo/screens/order_screen.dart';
import 'package:internal_app_demo/widgets/custom_button.dart';
import '../models/product.dart';
import '../models/customer_type.dart';
import '../services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;
  CustomerType _selectedCustomerType = CustomerType.dealer;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = ApiService();
      final products = await apiService.fetchProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Products',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BarcodeScannerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCustomerTypeSelector(),
          Expanded(
            child: _isLoading
                ? _buildLoadingWidget()
                : _error != null
                ? _buildErrorWidget()
                : _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerTypeSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Customer Type:',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SegmentedButton<CustomerType>(
              segments: [
                ButtonSegment(
                  value: CustomerType.dealer,
                  label: Text(
                    'Dealer',
                    style: GoogleFonts.poppins(fontSize: 12.sp),
                  ),
                  icon: const Icon(Icons.business, size: 18),
                ),
                ButtonSegment(
                  value: CustomerType.retail,
                  label: Text(
                    'Retail',
                    style: GoogleFonts.poppins(fontSize: 12.sp),
                  ),
                  icon: const Icon(Icons.store, size: 18),
                ),
              ],
              selected: {_selectedCustomerType},
              onSelectionChanged: (Set<CustomerType> newSelection) {
                setState(() {
                  _selectedCustomerType = newSelection.first;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text(
            'Loading products...',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error: $_error',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Retry',
            onPressed: _fetchProducts,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final price = _selectedCustomerType == CustomerType.dealer
            ? product.dealerPrice
            : product.retailPrice;

        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderScreen(
                    product: product,
                    customerType: _selectedCustomerType,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      size: 24.sp,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'MOQ: ${product.moq} units',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${price.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _selectedCustomerType.shortName,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}