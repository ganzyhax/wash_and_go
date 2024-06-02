import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/domain/entities/washes.dart';
import 'package:intl/intl.dart';
import 'package:wash_and_go/presentation/screens/box/bloc/box_bloc.dart';
import 'package:wash_and_go/presentation/screens/box/components/box_comment_card.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/bloc/main_navigator_bloc.dart';
import 'package:wash_and_go/presentation/screens/map/bloc/map_bloc.dart';
import 'package:wash_and_go/presentation/screens/search/bloc/search_bloc.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/custom_snackbar.dart';
import 'package:wash_and_go/presentation/widgets/fields/custom_textfiled.dart';

class BoxScreen extends StatelessWidget {
  final String title;
  final CarWahserEntity wash;
  const BoxScreen({super.key, required this.title, required this.wash});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController comment = TextEditingController();
    DateTime today = DateTime.now();
    final format = DateFormat.Hm(); // Time format for parsing
    DateTime startDateTime = format.parse(wash.jobTime[0]);
    DateTime endDateTime = format.parse(wash.jobTime[1]);
    int totalHours = endDateTime.difference(startDateTime).inHours;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            BoxBloc()..add(BoxLoad(commentData: wash.comments)),
        child: SingleChildScrollView(
          child: BlocListener<BoxBloc, BoxState>(
            listener: (context, state) {
              if (state is BoxBookSuccess) {
                CustomSnackbar()
                    .showCustomSnackBar(context, 'Успешно забронировано!');
                Navigator.pop(context);
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(MainNavigatorChangePage(index: 1));
              }
              if (state is BoxBookBooked) {
                CustomSnackbar().showCustomSnackBar(
                    context, 'Это место уже забранировано!');
              }
            },
            child: BlocBuilder<BoxBloc, BoxState>(
              builder: (context, state) {
                if (state is BoxLoaded) {
                  double totalStar = 0;
                  for (var i = 0; i < state.comments.length; i++) {
                    totalStar =
                        totalStar + double.parse(state.comments[i]['star']);
                  }
                  totalStar = totalStar / state.comments.length;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageSlideshow(
                          indicatorColor: Colors.deepPurple,
                          onPageChanged: (value) {
                            debugPrint('Page changed: $value');
                          },
                          autoPlayInterval: 8000,
                          isLoop: true,
                          children: wash.images.map<Widget>((e) {
                            return Image.network(
                              e,
                              fit: BoxFit.cover,
                            );
                          }).toList()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<BoxBloc>(context)
                                      ..add(BoxChangeTabIndex(index: 0));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: (state.selectedTab == 0)
                                            ? Colors.deepPurpleAccent
                                            : Colors.deepPurpleAccent
                                                .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: EdgeInsets.only(
                                        top: 7, bottom: 7, right: 10, left: 10),
                                    child: Center(
                                        child: Text(
                                      'Обзор',
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
                                    BlocProvider.of<BoxBloc>(context)
                                      ..add(BoxChangeTabIndex(index: 1));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: (state.selectedTab == 1)
                                            ? Colors.deepPurpleAccent
                                            : Colors.deepPurpleAccent
                                                .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: EdgeInsets.only(
                                        top: 7, bottom: 7, right: 10, left: 10),
                                    child: Center(
                                        child: Text(
                                      'Отзыв',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            (state.selectedTab == 0)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(wash.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18)),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                (totalStar.toString() == 'NaN')
                                                    ? '0.0'
                                                    : totalStar
                                                        .toStringAsFixed(1),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(wash.description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: Colors.grey[500])),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.deepPurple,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            wash.adress,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.watch_later_outlined,
                                            color: Colors.deepPurple,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            wash.jobTime[0] +
                                                ' - ' +
                                                wash.jobTime[1],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: Colors.deepPurple,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            wash.phone,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Выбрать тип',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              BlocProvider.of<BoxBloc>(context)
                                                ..add(BoxChooseType(index: 0));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: (state.type == 0)
                                                          ? Colors.deepPurple
                                                          : Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Седан',
                                                    style: TextStyle(),
                                                  ),
                                                  Text(
                                                    wash.prices[0] + '₸',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.deepPurple,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              BlocProvider.of<BoxBloc>(context)
                                                ..add(BoxChooseType(index: 1));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: (state.type == 1)
                                                          ? Colors.deepPurple
                                                          : Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Кроссовер',
                                                    style: TextStyle(),
                                                  ),
                                                  Text(
                                                    wash.prices[1] + '₸',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.deepPurple,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              BlocProvider.of<BoxBloc>(context)
                                                ..add(BoxChooseType(index: 2));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: (state.type == 2)
                                                          ? Colors.deepPurple
                                                          : Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Пикап',
                                                    style: TextStyle(),
                                                  ),
                                                  Text(
                                                    wash.prices[2] + '₸',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.deepPurple,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Выбрать дату',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
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
                                            DateTime date = today
                                                .add(Duration(days: index));
                                            // Format the date as a string
                                            String dateString =
                                                DateFormat('d MMMM', 'ru')
                                                    .format(date);

                                            // Create a container for each date
                                            return InkWell(
                                              onTap: () {
                                                BlocProvider.of<BoxBloc>(
                                                    context)
                                                  ..add(BoxChooseDate(
                                                      index: index,
                                                      date: dateString));
                                              },
                                              child: Container(
                                                height: 70,
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                padding: EdgeInsets.all(5),
                                                // padding: const EdgeInsets.symmetric(
                                                //     horizontal: 16.0, vertical: 24.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
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
                                                        dateString
                                                            .split(' ')[1],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
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
                                            DateTime currentHour = startDateTime
                                                .add(Duration(hours: index));
                                            DateTime nextHour = currentHour
                                                .add(Duration(hours: 1));
                                            String timeRange =
                                                format.format(currentHour) +
                                                    '-' +
                                                    format.format(nextHour);
                                            bool isBooked = false;

                                            for (var i = 0;
                                                i < wash.booking.length;
                                                i++) {
                                              if (wash.booking[i]['date'] ==
                                                      state.strDate &&
                                                  wash.booking[i]['time'] ==
                                                      timeRange &&
                                                  wash.booking[i]['box'] ==
                                                      (int.parse(
                                                              wash.washCount))
                                                          .toString()) {
                                                isBooked = true;
                                              }
                                            }
                                            return InkWell(
                                              onTap: () {
                                                if (isBooked != true) {
                                                  BlocProvider.of<BoxBloc>(
                                                      context)
                                                    ..add(BoxChooseTime(
                                                        index: index,
                                                        time: timeRange));
                                                } else {
                                                  const snackBar = SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content:
                                                        Text('Не свободно!'),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                              child: Container(
                                                width:
                                                    100, // Fixed width for each container
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  border: Border.all(
                                                      color: (isBooked == true)
                                                          ? Colors.red
                                                          : (state.time ==
                                                                  index)
                                                              ? Colors
                                                                  .deepPurple
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
                                      (state.isAvailable == false)
                                          ? CustomButton(
                                              isLoading: state.isLoading,
                                              isActive: (state.date != -1 &&
                                                      state.time != -1)
                                                  ? true
                                                  : false,
                                              function: () {
                                                BlocProvider.of<BoxBloc>(
                                                    context)
                                                  ..add(BoxBook(id: wash.id));
                                              },
                                              title: 'Забронировать')
                                          : SizedBox(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        // Set the scroll direction to horizontal
                                        itemCount: state.comments
                                            .length, // Number of items in the list
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: BoxCommentCard(
                                              data: state.comments[index],
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Оставить коментарии',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CustomTextField(
                                                  controller: name,
                                                  hintText: 'Ваше имя'),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CustomTextField(
                                                  controller: comment,
                                                  hintText: 'Коментария'),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Оценка',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children:
                                                    List.generate(5, (index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      int rate = index + 1;

                                                      BlocProvider.of<BoxBloc>(
                                                          context)
                                                        ..add(BoxChangeRate(
                                                            rate: rate));
                                                    },
                                                    child: Icon(
                                                      index < state.rate
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 35,
                                                    ),
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                child: CustomButton(
                                                    function: () {
                                                      if (name.text.length !=
                                                              0 &&
                                                          comment.text.length !=
                                                              0) {
                                                        if (state.rate == 0) {
                                                          BlocProvider.of<
                                                                      BoxBloc>(
                                                                  context)
                                                              .add(BoxAddComment(
                                                                  id: wash.id,
                                                                  comment:
                                                                      comment
                                                                          .text,
                                                                  name:
                                                                      name.text,
                                                                  rate: 1));
                                                        } else {
                                                          BlocProvider.of<
                                                                      BoxBloc>(
                                                                  context)
                                                              .add(BoxAddComment(
                                                                  id: wash.id,
                                                                  comment:
                                                                      comment
                                                                          .text,
                                                                  name:
                                                                      name.text,
                                                                  rate: state
                                                                      .rate));
                                                        }
                                                      } else {
                                                        CustomSnackbar()
                                                            .showCustomSnackBar(
                                                                context,
                                                                'Не заполнены обязательные поля!');
                                                      }
                                                    },
                                                    title: 'Оставить'),
                                              )
                                            ]),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
