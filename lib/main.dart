import 'package:flutter/material.dart';
import 'package:stripe/ExistingCardScreen.dart';
import 'package:get/get.dart';
import 'HomePage.dart';
import 'StripePaymentTest2.dart';

void main() => runApp(Stripe());

class Stripe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      initialRoute: '/HomePage',
      routes: {
        '/HomePage': (context) => HomePage(),
        '/ExistingCardScreen': (context) => ExistingCardScreen(),
        '/StripePaymentTest2': (context) => Payment(),
      },
    );
  }
}
