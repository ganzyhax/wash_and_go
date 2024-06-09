import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_and_go/presentation/screens/box/bloc/box_bloc.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/main_navigator.dart';
import 'package:wash_and_go/presentation/screens/payment/payment_modal.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/fields/custom_textfiled.dart';

class HomePaymentPage extends StatefulWidget {
  final String id;
  final String price;
  final BuildContext context2;
  const HomePaymentPage({
    super.key,
    required this.id,
    required this.context2,
    required this.price,
  });

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
            SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                'Оплата',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Детали кредитной карты',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(hintText: 'Имя на карте', controller: cardName),
            SizedBox(
              height: 10,
            ),
            CustomTextField(hintText: 'Номер карты', controller: cardNumber),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child:
                      CustomTextField(hintText: 'MM/YY', controller: cardDate),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomTextField(hintText: 'CVV', controller: cardCvv),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Промо код',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(hintText: 'Промо код', controller: promo),
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
                          'Промо код',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
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
                    'Общий',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  (promo.text == '2024')
                      ? Text(((double.parse(widget.price)) - 400)
                              .toStringAsFixed(0) +
                          ' KZT')
                      : Text((double.parse(widget.price)).toStringAsFixed(0) +
                          ' KZT')
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            CustomButton(
              title: 'Оплатить',
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

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomNavigationBar()));
              },
              isLoading: isLoading,
              isActive: (cardName.text.length != 0 &&
                      cardNumber.text.length != 0 &&
                      cardDate.text.length != 0 &&
                      cardCvv.text.length != 0)
                  ? true
                  : false,
            ),
          ],
        ),
      ),
    ));
  }
}
