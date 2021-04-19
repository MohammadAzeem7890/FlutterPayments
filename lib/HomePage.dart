import 'package:flutter/material.dart';
import 'package:stripe/ExistingCardScreen.dart';
import 'package:stripe/PaymentService.dart';
import 'package:get/get.dart';

import 'PaymentController.dart';

class HomePage extends StatelessWidget {
  final paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;
              switch (index) {
                case 0:
                  icon = Icon(
                    Icons.add_circle,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay via card');
                  break;
                case 1:
                  icon = Icon(
                    Icons.credit_card,
                    color: theme.primaryColor,
                  );
                  text = Text('Pay via existing card');
                  break;
              }
              return GestureDetector(
                onTap: () {
                  onCardPressed(context, index);
                },
                child: ListTile(
                  leading: icon,
                  title: text,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.black12,
                thickness: 2,
              );
            },
            itemCount: 2),
      ),
    );
  }

  onCardPressed(BuildContext context, int index) async {
    switch (index) {
      case 0:
        // print('lol');//
      // var bill = '235325.00';
        var response = await StripeService.payWithNewCard(
          amount: 235325.00,
          currency: 'eur',
        );
        if (response.success == true) {
          Get.snackbar('Transaction Status', response.massage,
              duration: Duration(milliseconds: 1200),
              backgroundColor: Colors.black,
              colorText: Colors.white,
              isDismissible: true);
          print('done');
        } else {}
        break;
      case 1:
        Navigator.pushNamed(context, '/ExistingCardScreen');
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => ExistingCardScreen()));
        break;
    }
  }
}
