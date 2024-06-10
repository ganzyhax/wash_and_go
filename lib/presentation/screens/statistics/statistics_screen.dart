import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/login/login_screen.dart';
import 'package:wash_and_go/presentation/screens/statistics/bloc/statistics_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Статистика'),
            InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                },
                child: Icon(Icons.logout_outlined))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => StatisticsBloc()..add(StatisticsLoad()),
          child: BlocBuilder<StatisticsBloc, StatisticsState>(
            builder: (context, state) {
              if (state is StatisticsLoaded) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (state.data != null)
                        ? Column(children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Броны',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<StatisticsBloc>(context)
                                        ..add(StatisticsChangeIndex(index: 0));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: (state.index == 0)
                                              ? Colors.deepPurpleAccent
                                              : Colors.deepPurpleAccent
                                                  .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: EdgeInsets.only(
                                          top: 7,
                                          bottom: 7,
                                          right: 10,
                                          left: 10),
                                      child: Center(
                                          child: Text(
                                        'Сегодняшний',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<StatisticsBloc>(context)
                                        ..add(StatisticsChangeIndex(index: 1));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: (state.index == 1)
                                              ? Colors.deepPurpleAccent
                                              : Colors.deepPurpleAccent
                                                  .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: EdgeInsets.only(
                                          top: 7,
                                          bottom: 7,
                                          right: 10,
                                          left: 10),
                                      child: Center(
                                          child: Text(
                                        'Все',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(),
                            SizedBox(
                              height: 15,
                            ),
                            (state.data[state.index].length != 0)
                                ? ListView.builder(
                                    itemCount: (state.index == 0)
                                        ? state.data[0].length
                                        : state.data[1].length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Бокс: '),
                                                Text((state.index == 0)
                                                    ? state.data[0][index]
                                                        ['box']
                                                    : state.data[1][index]
                                                        ['box'])
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Дата: '),
                                                Text((state.index == 0)
                                                    ? state.data[0][index]
                                                        ['date']
                                                    : state.data[1][index]
                                                        ['date'])
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Время: '),
                                                Text((state.index == 0)
                                                    ? state.data[0][index]
                                                        ['time']
                                                    : state.data[1][index]
                                                        ['time'])
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Тип: '),
                                                Text((state.index == 0)
                                                    ? (state.data[0][index]
                                                                ['type'] ==
                                                            '0'
                                                        ? 'Седан'
                                                        : state.data[0][index]
                                                                    ['type'] ==
                                                                '1'
                                                            ? 'Кроссовер'
                                                            : 'Пикап')
                                                    : state.data[1][index]
                                                                ['type'] ==
                                                            '0'
                                                        ? 'Седан'
                                                        : state.data[1][index]
                                                                    ['type'] ==
                                                                '1'
                                                            ? 'Кроссовер'
                                                            : 'Пикап')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('Телефон клиента: '),
                                                Text((state.index == 0)
                                                    ? '${state.data[0][index]['phone'] ?? 'Админ'}'
                                                    : '${state.data[1][index]['phone'] ?? 'Админ'}')
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Text('Нет бронов!'),
                                  ),
                            SizedBox(
                              height: (kIsWeb) ? 140 : 20,
                            )
                          ])
                        : Center(
                            child: Text('У вас нету мойки, создайте.'),
                          ));
              }
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
