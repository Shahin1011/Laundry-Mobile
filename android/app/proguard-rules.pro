# Stripe Push Provisioning Fix
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

# React Native Stripe SDK (sometimes required by embedded libs)
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**
