import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/login/bloc/login_bloc.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/main_navigator.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/custom_snackbar.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;
  final String pinCode;
  final bool isCreater;
  final String password;
  final String name;
  final String surname;
  final String carNumber;
  const VerifyScreen(
      {Key? key,
      required this.phone,
      required this.password,
      required this.pinCode,
      required this.isCreater,
      required this.name,
      required this.surname,
      required this.carNumber})
      : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  static const maxTime = 3 * 60; // 3 минуты в секундах
  int remainingTime = maxTime;
  Timer? _timer;
  bool isSms = false;

  void startTimer() {
    _timer?.cancel(); // Отменяем предыдущий таймер, если он был запущен
    remainingTime = maxTime; // Сбрасываем время до начального значения
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        setState(() {
          isSms = true;
        });

        _timer?.cancel();
      }
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
    );

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Верификация'),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                OtpHeader(address: widget.phone),
                SizedBox(
                  height: 68,
                  child: Pinput(
                    length: 6,
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (code) async {
                      if (widget.pinCode == code) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        String? userId =
                            await PhoneVerification().createUserWithAutoId(
                          widget.phone,
                          widget.isCreater,
                          widget.password,
                          widget.name,
                          widget.surname,
                          widget.carNumber,
                        );
                        if (userId != null) {
                          if (widget.isCreater) {
                            await prefs.setBool('isCreater', true);
                          } else {
                            await prefs.setBool('isCreater', false);
                          }
                          await prefs.setString('id', userId);
                          Position position =
                              await Geolocator.getCurrentPosition();
                          prefs.setStringList('location', [
                            position.longitude.toString(),
                            position.latitude.toString()
                          ]);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => CustomNavigationBar()),
                              (Route<dynamic> route) => false);
                        } else {
                          CustomSnackbar().showCustomSnackBar(
                              context, 'Ошибка при создании аккаунта!');
                        }
                      } else {
                        CustomSnackbar().showCustomSnackBar(
                            context, 'Не правильный пин код');
                      }
                    },
                    focusedPinTheme: defaultPinTheme.copyWith(
                      height: 68,
                      width: 64,
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Не получили код? ',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.44,
                        ),
                      ),
                      TextSpan(
                        text: (isSms == true)
                            ? 'Отправить еще раз'
                            : formatTime(remainingTime),
                        style: TextStyle(
                          color: Color(0xFF1D26FD),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.44,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 36),
                CustomButton(
                  function: () {},
                  // isLoading: ,
                  title: 'Отправить',
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OtpHeader extends StatelessWidget {
  final String address;

  const OtpHeader({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Забыли пароль?',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Введите код, отправленный на номер',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '+7 $address',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }
}
