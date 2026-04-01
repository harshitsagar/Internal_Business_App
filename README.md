# Internal Business App

A Flutter-based internal business application for order management and barcode scanning.

## Features

### Order Management
- Product listing with name, price, and MOQ
- Customer type toggle (Dealer/Retail with different pricing)
- Order placement with MOQ validation
- Real-time total price calculation

### Barcode Scanner
- Camera-based barcode scanning
- Validation logic (even-ending = valid, odd = invalid)
- Product name mapping from barcode

### API Integration
- Simulated API calls for product data
- Loading states and error handling

## Tech Stack
- Flutter
- Clean Architecture
- setState for state management
- flutter_screenutil for responsiveness
- google_fonts for typography
- mobile_scanner for barcode scanning

## Setup Instructions 🚀

1. **Clone repository**
   ```bash
   git clone https://github.com/harshitsagar/Internal_Business_App.git

2. **Install dependencies**
   ```bash
   flutter pub get

3. **Run the App**
   ```bash
    flutter run