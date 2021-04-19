import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe/PaymentService.dart';
import 'package:get/get.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ExistingCardScreen extends StatelessWidget {
  List existingCards = [
    {
      'cardNumber': '424242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Muhammad Azeem',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '3056930009020004',
      'expiryDate': '04/23',
      'cardHolderName': 'Hashlob',
      'cvvCode': '233',
      'showBackView': true,
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/23',
      'cardHolderName': 'Hashlob',
      'cvvCode': '233',
      'showBackView': true,
    },
    {
      'cardNumber': '6011111111111117',
      'expiryDate': '04/23',
      'cardHolderName': 'Hashlob',
      'cvvCode': '233',
      'showBackView': true,
    },
    {
      'cardNumber': '371449635398431',
      'expiryDate': '04/23',
      'cardHolderName': 'Hashlob',
      'cvvCode': '2323',
      'showBackView': true,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add Existing Card',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: existingCards.length,
          itemBuilder: (context, index) {
            var card = existingCards[index];
            return GestureDetector(
              onTap: () {
                payViaExistingCard(context, card, index);
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
              ),
            );
          }),
    );
  }

  payViaExistingCard(BuildContext context, card, index) async{
    // Navigator.pop(context);
    var expiryArr = existingCards[index]['expiryDate'].split('/');
    CreditCard existingCreditCard = CreditCard(
      number: existingCards[index]['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payWithExistingCard(
      currency: 'USD',
      amount: 1430.00,
      card: existingCreditCard,
    );
    if (response.success == true) {
      Get.snackbar('Transaction Status', response.massage,
          duration: Duration(milliseconds: 1200),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          isDismissible: true);
      print('existing done');
    }
    else{
      Get.snackbar('Transaction Status', response.massage,
          duration: Duration(milliseconds: 1200),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          isDismissible: true);
    }
  }
}
