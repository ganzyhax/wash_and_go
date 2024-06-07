import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wash_and_go/presentation/screens/payment/payment_modal.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/fields/custom_textfiled.dart';

class HomePaymentPage extends StatefulWidget {
  final resData;
  final localData;
  final selectedSeatsString;
  const HomePaymentPage(
      {super.key,
      required this.resData,
      required this.localData,
      required this.selectedSeatsString});

  @override
  State<HomePaymentPage> createState() => _HomePaymentPageState();
}

class _HomePaymentPageState extends State<HomePaymentPage> {
  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardDate = TextEditingController();
  TextEditingController cardCvv = TextEditingController();
  TextEditingController promo = TextEditingController();
  String cardNameString = '';
  String cardNumberString = '';
  String cardDateString = '';
  String cardCvvString = '';
  String promoString = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    cardName.addListener(() {
      setState(() {
        cardNameString = cardName.text;
      });
    });
    cardNumber.addListener(() {
      setState(() {
        cardNumberString = cardNumber.text;
      });
    });
    cardDate.addListener(() {
      setState(() {
        cardDateString = cardDate.text;
      });
    });
    cardCvv.addListener(() {
      setState(() {
        cardCvvString = cardCvv.text;
      });
    });
    promo.addListener(() {
      setState(() {
        promoString = promo.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [CustomBackButton()],
              // ),
              Center(
                child: Text(
                  'Payment',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 10,
              ),
              Text(
                'Credit card details',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(hintText: 'Name on card', controller: cardName),
              SizedBox(
                height: 10,
              ),
              CustomTextField(hintText: 'Card number', controller: cardNumber),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                        hintText: 'MM/YY', controller: cardDate),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                        CustomTextField(hintText: 'CVV', controller: cardCvv),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Promo code',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(hintText: 'Promo code', controller: promo),
              SizedBox(
                height: 10,
              ),
              (promo.text == '2024')
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Promo code',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text('400' + ' KZT')
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    (promo.text == '2024')
                        ? Text(((double.parse(widget.localData['price']) *
                                        widget.selectedSeatsString.length) -
                                    400)
                                .toStringAsFixed(0) +
                            ' KZT')
                        : Text((double.parse(widget.localData['price']) *
                                    widget.selectedSeatsString.length)
                                .toStringAsFixed(0) +
                            ' KZT')
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              CustomButton(
                title: 'Confirm and pay',
                function: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentModal();
                    },
                  );
                  setState(() {
                    isLoading = true;
                  });
                  await Future.delayed(Duration(seconds: 5));
                },
                isLoading: isLoading,
                // isEnable: (cardName.text.length != 0 &&
                //         cardNumber.text.length != 0 &&
                //         cardDate.text.length != 0 &&
                //         cardCvv.text.length != 0)
                //     ? true
                //     : false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
