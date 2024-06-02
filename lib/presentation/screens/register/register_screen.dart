import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wash_and_go/presentation/screens/login/components/verify_page.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';
import 'package:wash_and_go/presentation/screens/login/login_screen.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/custom_snackbar.dart';
import 'package:wash_and_go/presentation/widgets/fields/custom_textfiled.dart';

import 'package:wash_and_go/presentation/widgets/fields/phone_textfield_data.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isCreater = false;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController carNumber = TextEditingController();
  bool passwordShow = true;
  bool passwordrShow = true;
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
                'Регистрация',
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
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Повторите пароль',
                controller: rPassword,
                isPassword: true,
                passwordShow: passwordrShow,
                onTapIcon: () {
                  setState(() {
                    if (passwordrShow) {
                      passwordrShow = false;
                    } else {
                      passwordrShow = true;
                    }
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Фамилия',
                controller: surname,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Имя',
                controller: name,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Номер машины',
                controller: carNumber,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text('Есть аккаунт? '),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false);
                        },
                        child: Text(
                          'Войти',
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text("Я владелец мойки"),
                value: isCreater,
                onChanged: (newValue) {
                  setState(() {
                    isCreater = newValue!;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              CustomButton(
                  function: () async {
                    final Random random = Random();
                    int pinCode = random.nextInt(900000) + 100000;
                    await PhoneVerification().sendVerificationCode(
                        generatedCode: pinCode.toString(),
                        phoneNumber:
                            '7' + phone.text.replaceAll(RegExp(r'\D'), ''));
                    if (rPassword.text == password.text) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyScreen(
                                  password: password.text,
                                  isCreater: isCreater,
                                  phone: phone.text,
                                  pinCode: pinCode.toString(),
                                  carNumber: carNumber.text,
                                  name: name.text,
                                  surname: surname.text,
                                )),
                      );
                    } else {
                      CustomSnackbar()
                          .showCustomSnackBar(context, 'Пароли не совпадают!');
                    }
                  },
                  title: 'Регистация')
            ],
          ),
        ),
      ),
    );
  }
}
