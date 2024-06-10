import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  ControlBloc() : super(ControlInitial()) {
    int type = 0;
    int date = 0;
    int time = 0;
    int box = 0;

    String strTime = '';
    String strDate = '';
    String lastBox = '';
    bool isLoading = false;
    Map<String, dynamic> data = {};
    on<ControlEvent>((event, emit) async {
      if (event is ControlLoad) {
        type = 0;
        date = -1;
        time = -1;
        box = 0;
        isLoading = false;
        strTime = '';
        strDate = '';
        lastBox = '';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userId = prefs.getString('id') ?? '';
        String wahserId =
            await PhoneVerification().getUserFieldById(userId, 'washerId');
        data = await PhoneVerification().getWasherById(wahserId);

        emit(ControlLoaded(
            date: date,
            type: type,
            time: time,
            data: data,
            isLoading: isLoading,
            box: box,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is ControlChooseType) {
        type = event.index;
        emit(ControlLoaded(
            date: date,
            type: type,
            time: time,
            data: data,
            isLoading: isLoading,
            box: box,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is ControlChooseBox) {
        box = event.index;
        emit(ControlLoaded(
            date: date,
            isLoading: isLoading,
            type: type,
            time: time,
            data: data,
            box: box,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is ControlChooseDate) {
        date = event.index;
        strDate = event.date;
        emit(ControlLoaded(
            date: date,
            type: type,
            isLoading: isLoading,
            time: time,
            data: data,
            box: box,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is ControlChooseTime) {
        time = event.index;
        strTime = event.time;
        emit(ControlLoaded(
            date: date,
            isLoading: isLoading,
            type: type,
            time: time,
            data: data,
            box: box,
            strDate: strDate,
            strTime: strTime));
      }

      if (event is ControlBook) {
        isLoading = true;
        emit(ControlLoaded(
            date: date,
            type: type,
            time: time,
            isLoading: isLoading,
            data: data,
            box: box,
            strDate: strDate,
            strTime: strTime));
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('washes')
            .doc(event.id)
            .get();

        Map<String, dynamic>? userData =
            documentSnapshot.data() as Map<String, dynamic>?;
        bool isFree = true;
        int lastBox = 0;
        for (var i = 0; i < userData!['booking'].length; i++) {
          if (userData['booking'][i]['date'] == strDate) {
            if (userData['booking'][i]['time'] == strTime) {
              if (userData['booking'][i]['box'] == userData['washCount']) {
                isFree = false;
              } else {
                lastBox = int.parse(userData['booking'][i]['box']);
              }
            }
          }
        }
        if (isFree) {
          DocumentReference documentReference =
              FirebaseFirestore.instance.collection('washes').doc(event.id);

          var data = {
            'box': (lastBox + 1).toString(),
            'date': strDate,
            'time': strTime,
            'id': 'Admin',
            'washID': event.id,
            'type': type.toString()
          };
          List bookings = userData['booking'];
          bookings.add(data);

          try {
            await documentReference.update({'booking': bookings});
            type = 0;
            date = -1;
            time = -1;
            strTime = '';
            strDate = '';

            emit(ControlSuccess());

            add(ControlLoad());
          } catch (e) {
            print("Error updating document: $e");
          }
        } else {
          emit(ControlBooked());
          isLoading = false;
          emit(ControlLoaded(
              date: date,
              type: type,
              time: time,
              isLoading: isLoading,
              data: data,
              box: box,
              strDate: strDate,
              strTime: strTime));
        }
      }
    });
  }
}
