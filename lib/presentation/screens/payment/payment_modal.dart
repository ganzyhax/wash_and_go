import 'dart:async';
import 'package:flutter/material.dart';

class PaymentModal extends StatefulWidget {
  @override
  _PaymentModalState createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Start loading when the modal is initialized
    _isLoading = true;
    _startLoading();
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLoading
                ? CircularProgressIndicator()
                : Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
            SizedBox(height: 20),
            _isLoading
                ? Text('Processing Payment...')
                : Text(
                    'Payment Success!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
