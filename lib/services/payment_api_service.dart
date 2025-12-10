import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_contants.dart';
import '../utils/token_service.dart';

class PaymentApiService {
  final String baseUrl = AppConstants.BASE_URL;

  /// Get authentication token
  Future<String?> _getAuthToken() async {
    return await TokenService().getToken();
  }

  /// Create payment intent for an order
  Future<Map<String, dynamic>> createPaymentIntent(String orderId) async {
    final token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/payment/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'orderId': orderId}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to create payment intent',
        );
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  /// Get payment status
  Future<Map<String, dynamic>> getPaymentStatus(String paymentIntentId) async {
    final token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/payment/status/$paymentIntentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to get payment status',
        );
      }
    } catch (e) {
      throw Exception('Error getting payment status: $e');
    }
  }

  /// Get order details by order ID
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to get order details',
        );
      }
    } catch (e) {
      throw Exception('Error getting order details: $e');
    }
  }

  /// Get payment history
  Future<Map<String, dynamic>> getPaymentHistory({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    final token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token');
    }

    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse('$baseUrl/api/payment/history')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to get payment history',
        );
      }
    } catch (e) {
      throw Exception('Error getting payment history: $e');
    }
  }
}

