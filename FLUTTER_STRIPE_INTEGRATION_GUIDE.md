# Flutter Stripe Payment Integration Guide

## Overview

This guide provides complete instructions for integrating Stripe payment processing in your Flutter mobile application. The backend API is already implemented and ready to use.

**Backend Base URL:** `https://your-api-domain.com` (or `http://localhost:3000` for development)

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Flutter Setup](#flutter-setup)
3. [Backend API Overview](#backend-api-overview)
4. [Payment Flow](#payment-flow)
5. [Implementation Steps](#implementation-steps)
6. [Code Examples](#code-examples)
7. [Error Handling](#error-handling)
8. [Testing](#testing)
9. [Production Checklist](#production-checklist)

---

## Prerequisites

### Required Accounts & Keys

1. **Stripe Account**
   - Sign up at https://stripe.com
   - Get your **Publishable Key** (starts with `pk_test_` for test mode)
   - Get it from: https://dashboard.stripe.com/test/apikeys

2. **Backend API Access**
   - Ensure you have the backend API base URL
   - Ensure user authentication is working (JWT tokens)

### Flutter Requirements

- Flutter SDK 3.0+
- Dart 3.0+
- iOS 11.0+ / Android API 21+

---

## Flutter Setup

### Step 1: Add Dependencies

Add these packages to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  stripe_payment: ^2.0.0  # Or use stripe_sdk/flutter_stripe
  # OR use the official Stripe Flutter SDK:
  flutter_stripe: ^10.1.1  # Recommended - official Stripe SDK
  
  # For API calls
  dio: ^5.4.0  # Or use http package
  
  # For secure storage (store tokens)
  flutter_secure_storage: ^9.0.0
  
  # For state management (if using)
  provider: ^6.1.1  # Or your preferred state management
```

**Recommended:** Use `flutter_stripe` (official Stripe Flutter SDK) for better support.

### Step 2: Install Packages

```bash
flutter pub get
```

### Step 3: Platform Configuration

#### iOS Configuration

1. **Add to `ios/Podfile`:**
```ruby
platform :ios, '11.0'
```

2. **Update `ios/Runner/Info.plist`:**
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### Android Configuration

1. **Update `android/app/build.gradle`:**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

2. **Update `android/build.gradle`:**
```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

---

## Backend API Overview

### Authentication

All payment endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

### Key Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/orders` | POST | Create order |
| `/api/payment/create-payment-intent` | POST | Create payment intent |
| `/api/payment/status/:payment_intent_id` | GET | Check payment status |
| `/api/payment/:payment_intent_id` | GET | Get payment details |
| `/api/payment/history` | GET | Get payment history |

---

## Payment Flow

### Complete Payment Flow Diagram

```
1. User creates order
   ↓
2. Backend returns order with paymentStatus: "pending"
   ↓
3. Frontend calls /api/payment/create-payment-intent
   ↓
4. Backend returns payment_intent_id and client_secret
   ↓
5. Frontend uses Stripe SDK to collect card details
   ↓
6. Frontend confirms payment with client_secret
   ↓
7. Stripe processes payment
   ↓
8. Backend receives webhook (payment_intent.succeeded)
   ↓
9. Backend updates order paymentStatus to "paid"
   ↓
10. Frontend polls or receives notification of success
```

---

## Implementation Steps

### Step 1: Initialize Stripe

Create a Stripe service class:

```dart
// lib/services/stripe_service.dart
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static const String publishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY';
  
  static Future<void> initialize() async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }
}
```

Initialize in your `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StripeService.initialize();
  runApp(MyApp());
}
```

### Step 2: Create API Service

```dart
// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String baseUrl = 'https://your-api-domain.com'; // or http://localhost:3000
  
  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';
  }
  
  // Get auth token
  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  // Create order
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final token = await _getAuthToken();
    _dio.options.headers['Authorization'] = 'Bearer $token';
    
    try {
      final response = await _dio.post('/api/orders', data: orderData);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Create payment intent
  Future<Map<String, dynamic>> createPaymentIntent(String orderId) async {
    final token = await _getAuthToken();
    _dio.options.headers['Authorization'] = 'Bearer $token';
    
    try {
      final response = await _dio.post(
        '/api/payment/create-payment-intent',
        data: {'orderId': orderId},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Get payment status
  Future<Map<String, dynamic>> getPaymentStatus(String paymentIntentId) async {
    final token = await _getAuthToken();
    _dio.options.headers['Authorization'] = 'Bearer $token';
    
    try {
      final response = await _dio.get(
        '/api/payment/status/$paymentIntentId',
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // Get payment history
  Future<Map<String, dynamic>> getPaymentHistory({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final token = await _getAuthToken();
    _dio.options.headers['Authorization'] = 'Bearer $token';
    
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      };
      
      final response = await _dio.get(
        '/api/payment/history',
        queryParameters: queryParams,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return error.response?.data['message'] ?? 'An error occurred';
      }
      return error.message ?? 'Network error';
    }
    return 'An unexpected error occurred';
  }
}
```

### Step 3: Create Payment Service

```dart
// lib/services/payment_service.dart
import 'package:flutter_stripe/flutter_stripe.dart';
import 'api_service.dart';

class PaymentService {
  final ApiService _apiService = ApiService();
  
  /// Complete payment flow
  /// Returns true if payment succeeded, false otherwise
  Future<PaymentResult> processPayment({
    required String orderId,
    required BuildContext context,
  }) async {
    try {
      // Step 1: Create payment intent
      final intentResponse = await _apiService.createPaymentIntent(orderId);
      
      if (!intentResponse['success']) {
        return PaymentResult(
          success: false,
          message: intentResponse['message'] ?? 'Failed to create payment intent',
        );
      }
      
      final paymentData = intentResponse['data'];
      final clientSecret = paymentData['client_secret'] as String;
      final paymentIntentId = paymentData['payment_intent_id'] as String;
      
      // Step 2: Initialize payment sheet
      await _initPaymentSheet(clientSecret);
      
      // Step 3: Present payment sheet
      await Stripe.instance.presentPaymentSheet();
      
      // Step 4: Verify payment status
      final statusResponse = await _apiService.getPaymentStatus(paymentIntentId);
      
      if (statusResponse['success'] && 
          statusResponse['data']['status'] == 'succeeded') {
        return PaymentResult(
          success: true,
          message: 'Payment successful',
          paymentIntentId: paymentIntentId,
        );
      }
      
      return PaymentResult(
        success: false,
        message: 'Payment verification failed',
      );
      
    } on StripeException catch (e) {
      return PaymentResult(
        success: false,
        message: _handleStripeError(e),
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        message: e.toString(),
      );
    }
  }
  
  /// Initialize payment sheet
  Future<void> _initPaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Laundry Delivery Service',
        style: ThemeMode.system,
      ),
    );
  }
  
  /// Handle Stripe errors
  String _handleStripeError(StripeException error) {
    switch (error.error.code) {
      case 'card_declined':
        return 'Your card was declined. Please try a different card.';
      case 'insufficient_funds':
        return 'Insufficient funds. Please use a different payment method.';
      case 'expired_card':
        return 'Your card has expired. Please use a different card.';
      case 'incorrect_cvc':
        return 'Incorrect security code. Please check and try again.';
      case 'processing_error':
        return 'An error occurred while processing your card. Please try again.';
      default:
        return error.error.message ?? 'Payment failed. Please try again.';
    }
  }
}

class PaymentResult {
  final bool success;
  final String message;
  final String? paymentIntentId;
  
  PaymentResult({
    required this.success,
    required this.message,
    this.paymentIntentId,
  });
}
```

### Step 4: Create Order Service

```dart
// lib/services/order_service.dart
import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();
  
  /// Create a new order
  Future<Map<String, dynamic>> createOrder({
    required String pickupDate,
    required String pickupTime,
    required String dropoffDate,
    required String dropoffTime,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required List<Map<String, dynamic>> bags,
  }) async {
    final orderData = {
      'pickupDate': pickupDate,
      'pickupTime': pickupTime,
      'dropoffDate': dropoffDate,
      'dropoffTime': dropoffTime,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'paymentMethod': 'stripe',
      'bags': bags,
    };
    
    return await _apiService.createOrder(orderData);
  }
  
  /// Get user orders
  Future<Map<String, dynamic>> getMyOrders({
    int page = 1,
    int limit = 10,
  }) async {
    // Implement using your existing orders endpoint
    // This is just an example structure
    return {};
  }
}
```

### Step 5: Create Payment Screen

```dart
// lib/screens/payment_screen.dart
import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../services/order_service.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  
  const PaymentScreen({Key? key, required this.orderId}) : super(key: key);
  
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isProcessing = false;
  String? _errorMessage;
  
  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    
    final result = await _paymentService.processPayment(
      orderId: widget.orderId,
      context: context,
    );
    
    setState(() {
      _isProcessing = false;
    });
    
    if (result.success) {
      // Payment successful
      Navigator.of(context).pushReplacementNamed('/payment-success');
    } else {
      // Payment failed
      setState(() {
        _errorMessage = result.message;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Pay Now',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Your payment is secured by Stripe.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 6: Complete Order Flow Example

```dart
// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  
  const CheckoutScreen({Key? key, required this.orderData}) : super(key: key);
  
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderService _orderService = OrderService();
  bool _isCreatingOrder = false;
  
  Future<void> _createOrderAndPay() async {
    setState(() {
      _isCreatingOrder = true;
    });
    
    try {
      // Step 1: Create order
      final orderResponse = await _orderService.createOrder(
        pickupDate: widget.orderData['pickupDate'],
        pickupTime: widget.orderData['pickupTime'],
        dropoffDate: widget.orderData['dropoffDate'],
        dropoffTime: widget.orderData['dropoffTime'],
        fullName: widget.orderData['fullName'],
        email: widget.orderData['email'],
        phone: widget.orderData['phone'],
        address: widget.orderData['address'],
        city: widget.orderData['city'],
        state: widget.orderData['state'],
        zipCode: widget.orderData['zipCode'],
        bags: widget.orderData['bags'],
      );
      
      if (orderResponse['success']) {
        final orderId = orderResponse['data']['_id'];
        
        // Step 2: Navigate to payment screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentScreen(orderId: orderId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderResponse['message'] ?? 'Failed to create order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isCreatingOrder = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          // Order summary widget
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Display order details
                Text('Total: \$${widget.orderData['totalPrice']}'),
                // ... other order details
              ],
            ),
          ),
          
          // Pay button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isCreatingOrder ? null : _createOrderAndPay,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isCreatingOrder
                  ? const CircularProgressIndicator()
                  : const Text('Proceed to Payment'),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Code Examples

### Example 1: Complete Payment Flow

```dart
// Complete example showing full flow
class PaymentFlowExample {
  final ApiService _apiService = ApiService();
  final PaymentService _paymentService = PaymentService();
  
  Future<void> completePaymentFlow(String orderId) async {
    try {
      // 1. Create payment intent
      final intentResponse = await _apiService.createPaymentIntent(orderId);
      
      if (!intentResponse['success']) {
        throw Exception(intentResponse['message']);
      }
      
      final clientSecret = intentResponse['data']['client_secret'];
      final paymentIntentId = intentResponse['data']['payment_intent_id'];
      
      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Laundry Delivery',
        ),
      );
      
      // 3. Present payment sheet
      await Stripe.instance.presentPaymentSheet();
      
      // 4. Verify payment
      final statusResponse = await _apiService.getPaymentStatus(paymentIntentId);
      
      if (statusResponse['data']['status'] == 'succeeded') {
        print('Payment successful!');
      }
      
    } on StripeException catch (e) {
      print('Stripe error: ${e.error.message}');
    } catch (e) {
      print('Error: $e');
    }
  }
}
```

### Example 2: Payment History

```dart
class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _payments = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }
  
  Future<void> _loadPaymentHistory() async {
    try {
      final response = await _apiService.getPaymentHistory(page: 1, limit: 20);
      
      if (response['success']) {
        setState(() {
          _payments = response['data']['payments'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment History')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _payments.length,
              itemBuilder: (context, index) {
                final payment = _payments[index];
                return ListTile(
                  title: Text('Amount: \$${payment['amount']}'),
                  subtitle: Text('Status: ${payment['status']}'),
                  trailing: Text(
                    _formatDate(payment['createdAt']),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
    );
  }
  
  String _formatDate(String dateString) {
    // Format date for display
    return dateString;
  }
}
```

---

## Error Handling

### Stripe Error Codes

```dart
String handleStripeError(StripeException error) {
  switch (error.error.code) {
    case 'card_declined':
      return 'Your card was declined. Please try a different card.';
    case 'insufficient_funds':
      return 'Insufficient funds. Please use a different payment method.';
    case 'expired_card':
      return 'Your card has expired. Please use a different card.';
    case 'incorrect_cvc':
      return 'Incorrect security code. Please check and try again.';
    case 'incorrect_number':
      return 'Invalid card number. Please check and try again.';
    case 'processing_error':
      return 'An error occurred while processing your card. Please try again.';
    case 'generic_decline':
      return 'Your card was declined. Please contact your bank.';
    default:
      return error.error.message ?? 'Payment failed. Please try again.';
  }
}
```

### API Error Handling

```dart
class ApiErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data['message'];
      
      switch (statusCode) {
        case 400:
          return message ?? 'Invalid request. Please check your input.';
        case 401:
          return 'Authentication failed. Please login again.';
        case 403:
          return 'You do not have permission to perform this action.';
        case 404:
          return 'Resource not found.';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return message ?? 'An error occurred. Please try again.';
      }
    }
    return 'An unexpected error occurred.';
  }
}
```

---

## Testing

### Test Cards

Use these test card numbers in development:

| Card Number | Description |
|-------------|-------------|
| `4242 4242 4242 4242` | Visa - Success |
| `4000 0000 0000 0002` | Visa - Declined |
| `4000 0000 0000 9995` | Visa - Insufficient Funds |
| `5555 5555 5555 4444` | Mastercard - Success |

**Test Card Details:**
- **Expiry:** Any future date (e.g., 12/25)
- **CVC:** Any 3 digits (e.g., 123)
- **ZIP:** Any 5 digits (e.g., 12345)

### Testing Checklist

- [ ] Payment intent creation works
- [ ] Payment sheet displays correctly
- [ ] Card input validation works
- [ ] Successful payment flow
- [ ] Failed payment handling
- [ ] Payment status checking
- [ ] Payment history display
- [ ] Error messages display correctly
- [ ] Loading states work properly
- [ ] Network error handling

---

## API Endpoints Reference

### 1. Create Payment Intent

**Endpoint:** `POST /api/payment/create-payment-intent`

**Request:**
```json
{
  "orderId": "order_id_here"
}
```

**Response:**
```json
{
  "success": true,
  "status": 201,
  "message": "Payment intent created successfully",
  "data": {
    "payment_intent_id": "pi_xxxxx",
    "client_secret": "pi_xxxxx_secret_xxxxx",
    "amount": 244.00,
    "currency": "usd",
    "transaction_id": "TXN-123456"
  }
}
```

**Flutter Implementation:**
```dart
final response = await _apiService.createPaymentIntent(orderId);
final clientSecret = response['data']['client_secret'];
```

### 2. Get Payment Status

**Endpoint:** `GET /api/payment/status/:payment_intent_id`

**Response:**
```json
{
  "success": true,
  "data": {
    "payment_intent_id": "pi_xxxxx",
    "status": "succeeded",
    "amount": 244.00,
    "currency": "usd"
  }
}
```

**Flutter Implementation:**
```dart
final response = await _apiService.getPaymentStatus(paymentIntentId);
final status = response['data']['status'];
```

### 3. Get Payment History

**Endpoint:** `GET /api/payment/history?page=1&limit=10`

**Response:**
```json
{
  "success": true,
  "data": {
    "payments": [...],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 25,
      "pages": 3
    }
  }
}
```

---

## Complete Implementation Example

### Full Payment Widget

```dart
// lib/widgets/payment_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../services/api_service.dart';

class PaymentWidget extends StatefulWidget {
  final String orderId;
  final double amount;
  final Function(bool success, String? message) onPaymentComplete;
  
  const PaymentWidget({
    Key? key,
    required this.orderId,
    required this.amount,
    required this.onPaymentComplete,
  }) : super(key: key);
  
  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  
  Future<void> _handlePayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Step 1: Create payment intent
      final intentResponse = await _apiService.createPaymentIntent(widget.orderId);
      
      if (!intentResponse['success']) {
        throw Exception(intentResponse['message']);
      }
      
      final clientSecret = intentResponse['data']['client_secret'] as String;
      final paymentIntentId = intentResponse['data']['payment_intent_id'] as String;
      
      // Step 2: Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Laundry Delivery Service',
          style: ThemeMode.system,
        ),
      );
      
      // Step 3: Present payment sheet
      await Stripe.instance.presentPaymentSheet();
      
      // Step 4: Verify payment
      await Future.delayed(const Duration(seconds: 2)); // Wait for webhook
      
      final statusResponse = await _apiService.getPaymentStatus(paymentIntentId);
      
      if (statusResponse['success'] && 
          statusResponse['data']['status'] == 'succeeded') {
        widget.onPaymentComplete(true, 'Payment successful');
      } else {
        widget.onPaymentComplete(false, 'Payment verification failed');
      }
      
    } on StripeException catch (e) {
      final errorMessage = _handleStripeError(e);
      widget.onPaymentComplete(false, errorMessage);
    } catch (e) {
      widget.onPaymentComplete(false, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  String _handleStripeError(StripeException error) {
    switch (error.error.code) {
      case 'card_declined':
        return 'Your card was declined. Please try a different card.';
      case 'insufficient_funds':
        return 'Insufficient funds. Please use a different payment method.';
      case 'expired_card':
        return 'Your card has expired. Please use a different card.';
      default:
        return error.error.message ?? 'Payment failed. Please try again.';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        
        ElevatedButton(
          onPressed: _isLoading ? null : _handlePayment,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blue,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Pay \$${widget.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/stripe_logo.png', // Add Stripe logo asset
              height: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Secured by Stripe',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## State Management Example (Provider)

```dart
// lib/providers/payment_provider.dart
import 'package:flutter/foundation.dart';
import '../services/payment_service.dart';
import '../services/api_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  final ApiService _apiService = ApiService();
  
  bool _isProcessing = false;
  String? _errorMessage;
  List<dynamic> _paymentHistory = [];
  
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  List<dynamic> get paymentHistory => _paymentHistory;
  
  Future<bool> processPayment(String orderId) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _paymentService.processPayment(orderId: orderId);
      
      _isProcessing = false;
      _errorMessage = result.success ? null : result.message;
      notifyListeners();
      
      return result.success;
    } catch (e) {
      _isProcessing = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<void> loadPaymentHistory() async {
    try {
      final response = await _apiService.getPaymentHistory();
      if (response['success']) {
        _paymentHistory = response['data']['payments'];
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
```

---

## Best Practices

### 1. Security

- ✅ **Never store card details** on device
- ✅ **Use secure storage** for auth tokens
- ✅ **Always use HTTPS** in production
- ✅ **Validate all inputs** before sending to API
- ✅ **Handle errors gracefully** without exposing sensitive info

### 2. User Experience

- ✅ **Show loading indicators** during payment processing
- ✅ **Provide clear error messages** to users
- ✅ **Allow retry** on payment failure
- ✅ **Show payment confirmation** after success
- ✅ **Display payment history** for transparency

### 3. Error Handling

- ✅ **Handle network errors** (offline, timeout)
- ✅ **Handle API errors** (400, 401, 500, etc.)
- ✅ **Handle Stripe errors** (card declined, etc.)
- ✅ **Log errors** for debugging (without sensitive data)
- ✅ **Show user-friendly messages**

### 4. Testing

- ✅ **Test with test cards** before production
- ✅ **Test error scenarios** (declined cards, network failures)
- ✅ **Test on both iOS and Android**
- ✅ **Test with different card types**
- ✅ **Test payment status polling**

---

## Production Checklist

Before going to production:

- [ ] Replace test publishable key with live key
- [ ] Update API base URL to production URL
- [ ] Enable webhook endpoint in Stripe Dashboard
- [ ] Add production webhook secret to backend
- [ ] Test with real cards (small amounts)
- [ ] Implement proper error logging
- [ ] Add analytics tracking
- [ ] Test on both iOS and Android devices
- [ ] Verify webhook delivery
- [ ] Test payment status updates
- [ ] Review security practices
- [ ] Add loading states and error handling
- [ ] Test offline scenarios
- [ ] Implement retry logic

---

## Troubleshooting

### Issue: Payment sheet doesn't appear

**Solutions:**
- Check Stripe publishable key is correct
- Verify `initPaymentSheet` was called before `presentPaymentSheet`
- Check client_secret is valid
- Ensure platform configuration is correct

### Issue: "Payment intent not found"

**Solutions:**
- Verify payment intent ID is correct
- Check payment intent wasn't already used
- Ensure payment intent is in correct status

### Issue: Webhook not received

**Solutions:**
- Verify webhook endpoint URL is correct
- Check webhook secret is set in backend
- Verify server is accessible from internet
- Check Stripe Dashboard webhook logs

### Issue: Payment status stays "pending"

**Solutions:**
- Check webhook was received by backend
- Verify webhook handler is working
- Check server logs for errors
- Manually trigger webhook from Stripe Dashboard

---

## Additional Resources

- **Stripe Flutter SDK:** https://pub.dev/packages/flutter_stripe
- **Stripe Documentation:** https://stripe.com/docs
- **Stripe Testing:** https://stripe.com/docs/testing
- **Backend API Docs:** See `STRIPE_PAYMENT_API_DOCUMENTATION.md`

---

## Support

For issues:
1. Check error messages in app logs
2. Check backend server logs
3. Check Stripe Dashboard for payment status
4. Review webhook delivery logs in Stripe Dashboard

---

**Last Updated:** 2025-01-27  
**Version:** 1.0.0

