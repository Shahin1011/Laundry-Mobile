# Flutter Stripe Integration - Quick Reference

## Quick Setup

### 1. Add Dependencies
```yaml
dependencies:
  flutter_stripe: ^10.1.1
  dio: ^5.4.0
  flutter_secure_storage: ^9.0.0
```

### 2. Initialize Stripe
```dart
// main.dart
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_YOUR_KEY';
  await Stripe.instance.applySettings();
  runApp(MyApp());
}
```

---

## Payment Flow (3 Steps)

### Step 1: Create Payment Intent
```dart
final response = await dio.post(
  '/api/payment/create-payment-intent',
  data: {'orderId': orderId},
);
final clientSecret = response.data['data']['client_secret'];
```

### Step 2: Present Payment Sheet
```dart
await Stripe.instance.initPaymentSheet(
  paymentSheetParameters: SetupPaymentSheetParameters(
    paymentIntentClientSecret: clientSecret,
    merchantDisplayName: 'Your App',
  ),
);
await Stripe.instance.presentPaymentSheet();
```

### Step 3: Verify Payment
```dart
final status = await dio.get('/api/payment/status/$paymentIntentId');
if (status.data['data']['status'] == 'succeeded') {
  // Payment successful!
}
```

---

## Complete Example

```dart
Future<void> pay(String orderId) async {
  try {
    // 1. Create payment intent
    final intent = await dio.post(
      '/api/payment/create-payment-intent',
      data: {'orderId': orderId},
    );
    final clientSecret = intent.data['data']['client_secret'];
    
    // 2. Show payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Laundry Service',
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    
    // 3. Success!
    print('Payment successful');
  } on StripeException catch (e) {
    print('Error: ${e.error.message}');
  }
}
```

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/orders` | POST | Create order |
| `/api/payment/create-payment-intent` | POST | Get client_secret |
| `/api/payment/status/:id` | GET | Check payment status |
| `/api/payment/history` | GET | Get payment history |

---

## Test Cards

| Card | Result |
|------|--------|
| `4242 4242 4242 4242` | Success |
| `4000 0000 0000 0002` | Declined |
| `4000 0000 0000 9995` | Insufficient Funds |

**Details:** Any future expiry, any CVC, any ZIP

---

## Error Handling

```dart
try {
  await Stripe.instance.presentPaymentSheet();
} on StripeException catch (e) {
  switch (e.error.code) {
    case 'card_declined':
      showError('Card declined');
      break;
    case 'insufficient_funds':
      showError('Insufficient funds');
      break;
    default:
      showError(e.error.message);
  }
}
```

---

## Common Issues

**Payment sheet doesn't show:**
- Check publishable key
- Verify `initPaymentSheet` called first
- Check client_secret is valid

**Payment stays pending:**
- Wait for webhook (2-5 seconds)
- Check backend webhook handler
- Verify webhook secret is set

---

**Full Documentation:** See `FLUTTER_STRIPE_INTEGRATION_GUIDE.md`

