import 'package:flutter_stripe/flutter_stripe.dart';

/// Stripe Service
/// 
/// IMPORTANT: Before using Stripe payments, you must:
/// 1. Get your Stripe publishable key from: https://dashboard.stripe.com/test/apikeys
/// 2. Replace 'pk_test_YOUR_PUBLISHABLE_KEY_HERE' below with your actual key
/// 3. For production, use your live publishable key (starts with 'pk_live_')
class StripeService {
  // TODO: Replace with your actual Stripe publishable key
  // Get it from: https://dashboard.stripe.com/test/apikeys
  // Test key format: pk_test_...
  // Live key format: pk_live_...
  static const String publishableKey = 'pk_test_51SRIL02I9GC3mJjzABxu6DNY35psD4zafC4zpPsZVxuwVGMuadrKYtpl64q5mWquY0dy1SiNjQyJAXdwe0g0wBsw00BrBBEaiz';
  
  static Future<void> initialize() async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }
}

