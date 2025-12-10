import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'payment_api_service.dart';

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

class PaymentService {
  final PaymentApiService _apiService = PaymentApiService();

  /// Complete payment flow
  /// Returns PaymentResult with success status and message
  Future<PaymentResult> processPayment({
    required String orderId,
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
      // If this succeeds without exception, payment was processed by Stripe
      await Stripe.instance.presentPaymentSheet();
      
      // Payment sheet succeeded - payment was confirmed by Stripe
      // The payment intent has been successfully confirmed
      // Now verify with backend (webhook may take a few seconds to update order)

      // Step 4: Verify payment status with retry logic
      // Check both payment intent status and order payment status
      // Webhook may take a few seconds to process
      int maxRetries = 5;
      int retryCount = 0;
      bool backendVerified = false;
      
      while (!backendVerified && retryCount < maxRetries) {
        // Wait before checking (first check after 2 seconds, then every 2 seconds)
        await Future.delayed(const Duration(seconds: 2));
        
        try {
          // Check both payment intent status and order payment status
          final statusResponse = await _apiService.getPaymentStatus(paymentIntentId);
          final orderResponse = await _apiService.getOrderDetails(orderId);
          
          // Log the responses for debugging
          print('Payment status check (attempt ${retryCount + 1}):');
          print('Payment Intent Status: $statusResponse');
          print('Order Details: $orderResponse');
          
          // Check payment intent status
          bool paymentIntentSucceeded = false;
          if (statusResponse['success'] == true) {
            final statusData = statusResponse['data'];
            final status = statusData['status'] as String?;
            print('Payment Intent status: $status');
            
            if (status == 'succeeded') {
              paymentIntentSucceeded = true;
            }
          }
          
          // Check order payment status
          bool orderPaid = false;
          if (orderResponse['success'] == true) {
            final orderData = orderResponse['data'];
            final orderPaymentStatus = orderData['paymentStatus'] as String?;
            print('Order paymentStatus: $orderPaymentStatus');
            
            if (orderPaymentStatus == 'paid') {
              orderPaid = true;
              backendVerified = true;
              return PaymentResult(
                success: true,
                message: 'Payment successful',
                paymentIntentId: paymentIntentId,
              );
            }
          }
          
          // If payment intent succeeded but order not yet updated
          if (paymentIntentSucceeded && !orderPaid) {
            print('Payment intent succeeded but order paymentStatus still pending');
            retryCount++;
            continue; // Keep retrying to check if order gets updated
          }
          
          // If payment intent is still processing
          if (statusResponse['success'] == true) {
            final statusData = statusResponse['data'];
            final status = statusData['status'] as String?;
            if (status == 'processing') {
              retryCount++;
              continue;
            }
          }
          
          retryCount++;
          
        } catch (e) {
          // Error calling APIs
          print('Error checking payment/order status: $e');
          retryCount++;
          if (retryCount >= maxRetries) {
            // Payment sheet succeeded, so payment was processed
            // Backend verification failed, but we trust Stripe's confirmation
            return PaymentResult(
              success: true,
              message: 'Payment processed successfully. Please check your order status.',
              paymentIntentId: paymentIntentId,
            );
          }
        }
      }

      // If we've exhausted retries
      // Since Stripe payment sheet succeeded, payment was processed
      // The webhook will update the order status eventually
      return PaymentResult(
        success: true,
        message: 'Payment processed successfully. Order status will be updated shortly.',
        paymentIntentId: paymentIntentId,
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
}

