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
            builder: (cont747ext, state) {
              if (state is StatisticsLoaded) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (state.data != null)
                        ? Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Сегодняшние броны',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              (state.data.length != 0)
                                  ? ListView.builder(
                                      itemCount: state.data.length,
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
                                                  Text(state.data[index]['box'])
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Дата: '),
                                                  Text(
                                                      state.data[index]['date'])
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Время: '),
                                                  Text(
                                                      state.data[index]['time'])
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Тип: '),
                                                  Text((state.data[index]
                                                              ['type'] ==
                                                          '0'
                                                      ? 'Седан'
                                                      : state.data[index]
                                                                  ['type'] ==
                                                              '1'
                                                          ? 'Кроссовер'
                                                          : 'Пикап'))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Телефон клиента: '),
                                                  Text('+7' +
                                                      state.data[index]
                                                          ['phone'])
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Text('На сегодня нет бронов!'),
                                    )
                            ],
                          )
                        : Center(
                            child: Text('У вас нету мойки, создайте.'),
                          ));
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
