import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/data/datasource/car_washer_remote_datasource.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/data/repositories/car_washer_repository_impl.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';
import 'package:wash_and_go/presentation/screens/login/login_screen.dart';
import 'package:wash_and_go/presentation/screens/profile/bloc/profile_bloc.dart';
import 'package:wash_and_go/presentation/widgets/fields/custom_textfiled.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String surname = '';
  String carNumber = '';
  String phone = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool isDateGreaterThanOrEqualToToday(String givenDate, String timeString) {
    var now = DateTime.now();

    // Parse the given date string
    var dateFormatter = DateFormat('dd MMMM', 'ru');
    var givenDateDay = dateFormatter.parse(givenDate);

    // Construct the given date with today's year
    var givenDateWithYear =
        DateTime(now.year, givenDateDay.month, givenDateDay.day);

    // Parse the given time string
    var timeFormatter = DateFormat('HH:mm');
    var givenTime = timeFormatter.parse(timeString.split('-')[0]);

    // Construct the given date and time
    var givenDateTime = DateTime(
        givenDateWithYear.year,
        givenDateWithYear.month,
        givenDateWithYear.day,
        givenTime.hour,
        givenTime.minute);

    // Check if the given date and time is after the current date and time
    return givenDateTime.isAfter(now);
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users') // Replace 'users' with your collection name
        .doc(prefs.getString('id'))
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      // Access fields like this:
      print('User Name: ${data['name']}');
      print('User Email: ${data['email']}');
      name = data['name'];
      surname = data['surname'];
      carNumber = data['carNumber'].toString().toUpperCase();
      phone = data['phone'];
      // Add other fields as needed
    } else {
      print('Document does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Профиль'),
            InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  await Geolocator.requestPermission();
                  Position position = await Geolocator.getCurrentPosition();
                  prefs.setStringList('location', [
                    position.longitude.toString(),
                    position.latitude.toString()
                  ]);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                },
                child: Icon(Icons.logout_rounded))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => ProfileBloc()..add(ProfileLoad()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50, // Image radius
                            backgroundImage: NetworkImage(
                              'https://louisville.edu/enrollmentmanagement/images/person-icon/image',
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name + ' ' + surname,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '+7' + phone,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                carNumber,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'История бронирование',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ListView.builder(
                          itemCount: state.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool canCencel = isDateGreaterThanOrEqualToToday(
                                state.data[index]['date'],
                                state.data[index]['time']);
                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Автомойка: '),
                                          Text(state.data[index]['washName'])
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Дата: '),
                                              Text(state.data[index]['date'])
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Row(
                                            children: [
                                              Text('Время: '),
                                              Text(state.data[index]['time'])
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  (canCencel == true)
                                      ? InkWell(
                                          onTap: () async {
                                            var data = state.data;
                                            data.removeAt(index);
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await PhoneVerification()
                                                .updateUserFieldById(
                                                    prefs
                                                        .getString('id')
                                                        .toString(),
                                                    'booking',
                                                    data);
                                            BlocProvider.of<ProfileBloc>(
                                                context)
                                              ..add(ProfileLoad());
                                          },
                                          child: InkWell(
                                            onTap: () async {
                                              CarWasherRepositoryImpl
                                                  repository =
                                                  CarWasherRepositoryImpl(
                                                remoteDataSource:
                                                    GetCarWasherRemoteDataSourceImpl(),
                                              );
                                              CarWahserModel washer =
                                                  await repository.getCarWasher(
                                                      state.data[index]
                                                          ['washID']);
                                              washer.booking.removeWhere(
                                                  (element) =>
                                                      element['date'] ==
                                                          state.data[index]
                                                              ['date'] &&
                                                      element['time'] ==
                                                          state.data[index]
                                                              ['time']);

                                              await repository
                                                  .updateCarWasher(washer);

                                              var data = state.data;
                                              data.removeAt(index);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await PhoneVerification()
                                                  .updateUserFieldById(
                                                      prefs
                                                          .getString('id')
                                                          .toString(),
                                                      'booking',
                                                      data);
                                              BlocProvider.of<ProfileBloc>(
                                                  context)
                                                ..add(ProfileLoad());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      Colors.deepPurpleAccent),
                                              child: Center(
                                                child: Text(
                                                  'Отменить\nбронь',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            );
                          }),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                );
              }
              return Container(
                child: Text('Загрузка...'),
              );
            },
          ),
        ),
      ),
    );
  }
}
