import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping_app/core/API/api_key.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/firebase_options.dart';
import 'package:shopping_app/shopping_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey = ApiKey.stripePublishableKey;
  await Stripe.instance.applySettings();
  setupDependencies();
  runApp(ShoppingApp());
}
