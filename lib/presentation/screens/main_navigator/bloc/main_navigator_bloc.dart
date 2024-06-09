import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/control/box_control_screen.dart';
import 'package:wash_and_go/presentation/screens/create/create_screen.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';
import 'package:wash_and_go/presentation/screens/map/map_screen.dart';
import 'package:wash_and_go/presentation/screens/profile/profile_screen.dart';
import 'package:wash_and_go/presentation/screens/search/search_screen.dart';
import 'package:wash_and_go/presentation/screens/statistics/statistics_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'main_navigator_event.dart';
part 'main_navigator_state.dart';

class MainNavigatorBloc extends Bloc<MainNavigatorEvent, MainNavigatorState> {
  MainNavigatorBloc() : super(MainNavigatorInitial()) {
    List screens = [
      MapScreen(),
      SearchScreen(),
      WashCreateScreen(),
      Container(),
      Container()
    ];
    int index = 0;
    bool isCreater = false;
    on<MainNavigatorEvent>((event, emit) async {
      if (event is MainNavigatorLoad) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String washerId = await PhoneVerification()
            .getUserFieldById(prefs.getString('id') ?? '', 'washerId');
        isCreater = await PhoneVerification()
            .getUserFieldById(prefs.getString('id') ?? '', 'isCreater');
        await prefs.setBool('isCreater', isCreater);
        if (washerId != '') {
          await prefs.setBool('isWashCreated', true);
        } else {
          await prefs.setBool('isWashCreated', false);
        }
        bool isWashCreated = prefs.getBool('isWashCreated') ?? false;

        if (isCreater == true) {
          if (!kIsWeb) {
            if (isWashCreated == true) {
              screens = [
                MapScreen(),
                BoxControllScreen(),
                StatisticsScreen(),
              ];
            } else {
              screens = [
                MapScreen(),
                WashCreateScreen(),
                StatisticsScreen(),
              ];
            }
          } else {
            if (isWashCreated == true) {
              screens = [
                SearchScreen(),
                BoxControllScreen(),
                StatisticsScreen(),
              ];
            } else {
              screens = [
                SearchScreen(),
                WashCreateScreen(),
                StatisticsScreen(),
              ];
            }
          }
        } else {
          if (!kIsWeb) {
            screens = [
              MapScreen(),
              SearchScreen(),
              ProfileScreen(),
            ];
          } else {
            screens = [
              SearchScreen(),
              ProfileScreen(),
            ];
          }
        }
        emit(MainNavigatorLoaded(
            index: index, screens: screens, isCreater: isCreater));
      }

      if (event is MainNavigatorChangePage) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        index = event.index;
        if (event.withChange == true) {
          final bool isCreated = await prefs.getBool('isWashCreated') ?? false;
          if (isCreated) {
            screens = [
              MapScreen(),
              BoxControllScreen(),
              StatisticsScreen(),
            ];
          }
        }
        emit(MainNavigatorLoaded(
          isCreater: isCreater,
          index: index,
          screens: screens,
        ));
      }
    });
  }
}
