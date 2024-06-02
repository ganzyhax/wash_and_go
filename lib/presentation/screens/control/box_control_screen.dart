import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wash_and_go/presentation/screens/control/bloc/control_bloc.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/custom_snackbar.dart';

class BoxControllScreen extends StatelessWidget {
  const BoxControllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Брон боксов'),
      ),
      body: BlocProvider(
        create: (context) => ControlBloc()..add(ControlLoad()),
        child: BlocListener<ControlBloc, ControlState>(
          listener: (context, state) {
            if (state is ControlSuccess) {
              CustomSnackbar()
                  .showCustomSnackBar(context, 'Успешно забронировано!');
            }
            // TODO: implement listener
          },
          child: BlocBuilder<ControlBloc, ControlState>(
            builder: (context, state) {
              if (state is ControlLoaded) {
                DateTime today = DateTime.now();

                final format = DateFormat.Hm(); // Time format for parsing
                DateTime startDateTime = format.parse(state.data['jobTime'][0]);
                DateTime endDateTime = format.parse(state.data['jobTime'][1]);
                int totalHours = endDateTime.difference(startDateTime).inHours;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Выбрать услугу',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                BlocProvider.of<ControlBloc>(context)
                                  ..add(ControlChooseType(index: 0));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (state.type == 0)
                                            ? Colors.deepPurple
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Седан',
                                      style: TextStyle(),
                                    ),
                                    Text(
                                      state.data['prices'][0] + '₸',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepPurple,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                BlocProvider.of<ControlBloc>(context)
                                  ..add(ControlChooseType(index: 1));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (state.type == 1)
                                            ? Colors.deepPurple
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Кроссовер',
                                      style: TextStyle(),
                                    ),
                                    Text(
                                      state.data['prices'][1] + '₸',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepPurple,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                BlocProvider.of<ControlBloc>(context)
                                  ..add(ControlChooseType(index: 2));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (state.type == 2)
                                            ? Colors.deepPurple
                                            : Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Пикап',
                                      style: TextStyle(),
                                    ),
                                    Text(
                                      state.data['prices'][2] + '₸',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepPurple,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Выбрать бокс',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: int.parse(state.data['washCount']),
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<ControlBloc>(context)
                                    ..add(ControlChooseBox(index: i));
                                },
                                child: Container(
                                  height: 50,
                                  width: 80,
                                  margin: const EdgeInsets.all(5.0),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: (state.box == i
                                          ? Colors.deepPurple
                                          : Colors
                                              .white), // If not all elements have a different date, set border to red
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Бокс ' + (i + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Выбрать дату',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 70,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 11,
                            itemBuilder: (context, index) {
                              // Add index days to today's date
                              DateTime date = today.add(Duration(days: index));
                              // Format the date as a string
                              String dateString =
                                  DateFormat('d MMMM', 'ru').format(date);

                              // Create a container for each date
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<ControlBloc>(context)
                                    ..add(ControlChooseDate(
                                        index: index, date: dateString));
                                },
                                child: Container(
                                  height: 70,
                                  margin: const EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(5),
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: 16.0, vertical: 24.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      // Check if all elements in the bookings array do not have the dateString
                                      color: (state.date == index
                                          ? Colors.deepPurple
                                          : Colors
                                              .white), // If not all elements have a different date, set border to red
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      dateString.split(' ')[0] +
                                          '\n' +
                                          dateString.split(' ')[1],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Выбрать время',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 70,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                totalHours, // Total hours between start and end
                            itemBuilder: (context, index) {
                              DateTime currentHour =
                                  startDateTime.add(Duration(hours: index));
                              DateTime nextHour =
                                  currentHour.add(Duration(hours: 1));
                              String timeRange = format.format(currentHour) +
                                  '-' +
                                  format.format(nextHour);
                              bool isBooked = false;
                              print(state.strDate);
                              print(timeRange);
                              print((state.box + 1).toString());
                              for (var i = 0;
                                  i < state.data['booking'].length;
                                  i++) {
                                if (state.data['booking'][i]['date'] ==
                                        state.strDate &&
                                    state.data['booking'][i]['time'] ==
                                        timeRange &&
                                    state.data['booking'][i]['box'] ==
                                        (state.box + 1).toString()) {
                                  isBooked = true;
                                }
                              }
                              return InkWell(
                                onTap: () {
                                  if (isBooked != true) {
                                    BlocProvider.of<ControlBloc>(context)
                                      ..add(ControlChooseTime(
                                          index: index, time: timeRange));
                                  } else {
                                    const snackBar = SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Не свободно!'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Container(
                                  width: 100, // Fixed width for each container
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                        color: (isBooked == true)
                                            ? Colors.red
                                            : (state.time == index)
                                                ? Colors.deepPurple
                                                : Colors.white),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    timeRange,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            isActive: (state.date != -1 && state.time != -1)
                                ? true
                                : false,
                            isLoading: state.isLoading,
                            function: () {
                              BlocProvider.of<ControlBloc>(context)
                                ..add(ControlBook(id: state.data['id']));
                            },
                            title: 'Забронировать')
                      ],
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
