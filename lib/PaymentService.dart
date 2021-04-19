import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:stripe/StripeTransactionResponse.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  static String apiBaseUrl = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBaseUrl}/payment_intents';
  static String secret =
      'sk_test_51IhEBcKHVg3RWoqaXEnLLoHJ1YM5jVPrVzqgJ1LmCSTqwAizfxYR5MPcdnClyk522za6qackJzjZQUJNWUpdvX0b00THUpNxvh';
  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51IhEBcKHVg3RWoqaNHHeLTG0EP06cKxyurwg9Ryik577ZA4oTYOgYXByit2OMpIPl14W2BwxqvCxLvVd7Y4qHtnc00zyPVPLbG',
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );
  }

  static Future<StripeTransactionResponse> payWithExistingCard(
      {double amount, String currency, CreditCard card}) async {
    var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card));
    var paymentIntent =
        await StripeService.createPaymentIntent(amount, currency);
    // print('This is payment Intent ${jsonEncode(paymentIntent)}');

    var confirmResponse = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id),
    );
    if (confirmResponse.status == 'succeeded') {
      return StripeTransactionResponse(
        massage: 'Transaction Successful',
        success: true,
      );
    } else {
      return StripeTransactionResponse(
        massage: 'Transaction Failed',
        success: false,
      );
    }
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {double amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      // print('This is payment Intent ${jsonEncode(paymentIntent)}');

      var confirmResponse = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
            clientSecret: paymentIntent['client_secret'],
            paymentMethodId: paymentMethod.id),
      );

      if (confirmResponse.status == 'succeeded') {
        return StripeTransactionResponse(
          massage: 'Transaction Successful',
          success: true,
        );
      } else {
        return StripeTransactionResponse(
          massage: 'Transaction Failed',
          success: false,
        );
      }
    } catch (err) {
      return StripeTransactionResponse(
        massage: 'Transaction Failed ${err}',
        success: false,
      );
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      double amount, String currency) async {
    try {
      var amount1 = amount.round();
      Map<String, dynamic> body = {
        'amount': '$amount1',
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        StripeService.paymentApiUrl,
        body: body,
        headers: {
          'Authorization': 'Bearer ${StripeService.secret}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("err charing user: " + e.toString());
    }
    return null;
  }

  // static Future<Map<String, dynamic>> addPaymentIntent(
  //     String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> formData = {
  //       'amount': amount,
  //       'currency': currency,
  //       'payment_method_types[]': 'amount',
  //     };
  //     var response = await http.post(
  //       StripeService.paymentApiUrl,
  //       body: formData,
  //       headers: {
  //         'Authorization': 'Bearer ${StripeService.secret}',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //     );
  //     return jsonDecode(response.body);
  //   } catch (error) {
  //     print('error charging user ${error}');
  //   }
  // }
}
