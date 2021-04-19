import 'package:get/get.dart';
import 'PaymentService.dart';

class PaymentController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    StripeService.init();
  }
}