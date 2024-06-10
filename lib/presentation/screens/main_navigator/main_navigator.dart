import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/bloc/main_navigator_bloc.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/components/navigator_item.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomNavigationBar extends StatelessWidget {
  CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainNavigatorBloc()..add(MainNavigatorLoad()),
      child: BlocBuilder<MainNavigatorBloc, MainNavigatorState>(
        builder: (context, state) {
          if (state is MainNavigatorLoaded) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.grey[100],
              body: Stack(
                children: [
                  state.screens[state.index],
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 30),
                        height: 70,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: (state.isCreater == true && !kIsWeb)
                                ? [
                                    InkWell(
                                      onTap: () {
                                        BlocProvider.of<MainNavigatorBloc>(
                                                context)
                                            .add(MainNavigatorChangePage(
                                                index: 0));
                                      },
                                      child: NavigationItem(
                                        assetImage: Icons.location_on_outlined,
                                        isSelected:
                                            (state.index == 0) ? true : false,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        BlocProvider.of<MainNavigatorBloc>(
                                                context)
                                            .add(MainNavigatorChangePage(
                                                index: 1));
                                      },
                                      child: NavigationItem(
                                        assetImage: Icons.local_car_wash,
                                        isSelected:
                                            (state.index == 1) ? true : false,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        BlocProvider.of<MainNavigatorBloc>(
                                                context)
                                            .add(MainNavigatorChangePage(
                                                index: 2));
                                      },
                                      child: NavigationItem(
                                        assetImage: Icons.dashboard_outlined,
                                        isSelected:
                                            (state.index == 2) ? true : false,
                                      ),
                                    ),
                                  ]
                                : (kIsWeb && state.isCreater == true)
                                    ? [
                                        InkWell(
                                          onTap: () {
                                            BlocProvider.of<MainNavigatorBloc>(
                                                    context)
                                                .add(MainNavigatorChangePage(
                                                    index: 0));
                                          },
                                          child: NavigationItem(
                                            assetImage:
                                                Icons.location_on_outlined,
                                            isSelected: (state.index == 0)
                                                ? true
                                                : false,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            BlocProvider.of<MainNavigatorBloc>(
                                                    context)
                                                .add(MainNavigatorChangePage(
                                                    index: 1));
                                          },
                                          child: NavigationItem(
                                            assetImage: Icons.local_car_wash,
                                            isSelected: (state.index == 1)
                                                ? true
                                                : false,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            BlocProvider.of<MainNavigatorBloc>(
                                                    context)
                                                .add(MainNavigatorChangePage(
                                                    index: 2));
                                          },
                                          child: NavigationItem(
                                            assetImage: Icons.dashboard,
                                            isSelected: (state.index == 2)
                                                ? true
                                                : false,
                                          ),
                                        ),
                                      ]
                                    : (!kIsWeb && state.isCreater == false)
                                        ? [
                                            InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                            MainNavigatorBloc>(
                                                        context)
                                                    .add(
                                                        MainNavigatorChangePage(
                                                            index: 0));
                                              },
                                              child: NavigationItem(
                                                assetImage: Icons.location_on,
                                                isSelected: (state.index == 0)
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                            MainNavigatorBloc>(
                                                        context)
                                                    .add(
                                                        MainNavigatorChangePage(
                                                            index: 1));
                                              },
                                              child: NavigationItem(
                                                assetImage: Icons.search,
                                                isSelected: (state.index == 1)
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                            MainNavigatorBloc>(
                                                        context)
                                                    .add(
                                                        MainNavigatorChangePage(
                                                            index: 2));
                                              },
                                              child: NavigationItem(
                                                assetImage:
                                                    Icons.dashboard_outlined,
                                                isSelected: (state.index == 2)
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ]
                                        : [
                                            InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                            MainNavigatorBloc>(
                                                        context)
                                                    .add(
                                                        MainNavigatorChangePage(
                                                            index: 0));
                                              },
                                              child: NavigationItem(
                                                assetImage: Icons.search,
                                                isSelected: (state.index == 0)
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                            MainNavigatorBloc>(
                                                        context)
                                                    .add(
                                                        MainNavigatorChangePage(
                                                            index: 1));
                                              },
                                              child: NavigationItem(
                                                assetImage: Icons.person,
                                                isSelected: (state.index == 1)
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ]),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
