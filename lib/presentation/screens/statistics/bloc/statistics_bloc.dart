import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsInitial()) {
    List resultData = [];
    on<StatisticsEvent>((event, emit) async {
      if (event is StatisticsLoad) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('d MMMM', 'ru').format(now);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('id') ?? '';
        String wahserId =
            await PhoneVerification().getUserFieldById(userId, 'washerId');
        if (wahserId != '') {
          var data = await PhoneVerification().getWasherById(wahserId);

          for (var i = 0; i < data['booking'].length; i++) {
            log(data['booking'][i].toString());
            log(formattedDate.toString());
            if (data['booking'][i]['date'] == formattedDate) {
              resultData.add(data['booking'][i]);
            }
          }
          emit(StatisticsLoaded(data: resultData));
        } else {
          emit(StatisticsLoaded(data: null));
        }
      }
    });
  }
}
