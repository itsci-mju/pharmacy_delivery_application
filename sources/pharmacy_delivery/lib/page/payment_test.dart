import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../utils/payment_widget.dart';


class Payment_Test extends StatefulWidget {
  const Payment_Test({Key? key}) : super(key: key);

  @override
  State<Payment_Test> createState() => _Payment_TestState();
}

class _Payment_TestState extends State<Payment_Test> {

  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Tutorial'),
      ),
      body: Center(
        child: InkWell(
          onTap: ()async{
            await makePayment('169');
          },
          child: Container(
            height: 50,
            width: 200,
            color: Colors.green,
            child: Center(
              child: Text('Pay' , style: TextStyle(color: Colors.white , fontSize: 20),),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {

      paymentIntentData = await PaymentWidget.createPaymentIntent(amount, 'THB'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
             // applePay: true,
             // googlePay: true,
              testEnv: true,
              style: ThemeMode.light,
              merchantCountryCode: 'TH',
              merchantDisplayName: 'Pharmacy Health Mate')).then((value){
      });

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue){


        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());

        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ชำระเงินสำเร็จ"));
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green,),
                      Text("ชำระเงินสำเร็จ",style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ],
              ),
            ));

        paymentIntentData = null;

      }).onError((error, stackTrace){
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }




}

