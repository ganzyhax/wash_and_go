import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/login/components/verify_page.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/main_navigator.dart';
import 'package:wash_and_go/presentation/screens/register/register_screen.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/custom_snackbar.dart';
import 'package:wash_and_go/presentation/widgets/fields/custom_textfiled.dart';

import 'package:wash_and_go/presentation/widgets/fields/phone_textfield_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isCreater = false;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passwordShow = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 150,
                  child: SvgPicture.asset(
                    'assets/images/wash_logo.svg',
                    color: Colors.deepPurple,
                  )),
              SizedBox(
                height: 0,
              ),
              Text(
                'Войти',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/kz-flag.png',
                          width: 24,
                        ),
                        Text(
                          '+7',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 3),
                  Flexible(
                    child: TextFieldInput(
                      hintText: 'Номер телефона',
                      textInputType: TextInputType.phone,
                      textEditingController: phone,
                      isPhoneInput: true,
                      autoFocus: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Пароль',
                controller: password,
                isPassword: true,
                passwordShow: passwordShow,
                onTapIcon: () {
                  setState(() {
                    if (passwordShow) {
                      passwordShow = false;
                    } else {
                      passwordShow = true;
                    }
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text('Нет аккаунта? '),
                      InkWell(
                        onTap: () {
                          // s
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                              (Route<dynamic> route) => false);
                        },
                        child: Text(
                          'Регистрация',
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              CustomButton(
                  function: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String userId = await PhoneVerification()
                            .login(phone.text, password.text) ??
                        '';
                    if (userId != '') {
                      await prefs.setString('id', userId);
                      await Geolocator.requestPermission();
                      Position position = await Geolocator.getCurrentPosition();
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
                          context, 'Неверный логин или пароль!');
                    }
                  },
                  title: 'Войти')
            ],
          ),
        ),
      ),
    );
  }
}
