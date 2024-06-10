import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';

part 'box_event.dart';
part 'box_state.dart';

class BoxBloc extends Bloc<BoxEvent, BoxState> {
  BoxBloc() : super(BoxInitial()) {
    int type = 0;
    int date = -1;
    int time = -1;
    String strTime = '';
    String strDate = '';
    String lastBox = '';
    List comments = [];
    int rate = 0;
    bool isAvailable = true;
    bool isLoading = false;
    int selectedTab = 0;
    on<BoxEvent>((event, emit) async {
      if (event is BoxLoad) {
        type = 0;
        date = -1;
        time = -1;
        strTime = '';
        strDate = '';
        isLoading = false;
        lastBox = '';
        comments = event.commentData;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        isAvailable = prefs.getBool('isCreater') ?? true;
        emit(BoxLoaded(
            isLoading: isLoading,
            isAvailable: isAvailable,
            date: date,
            selectedTab: selectedTab,
            type: type,
            time: time,
            rate: rate,
            comments: comments,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is BoxChooseType) {
        type = event.index;
        emit(BoxLoaded(
            isAvailable: isAvailable,
            comments: comments,
            date: date,
            type: type,
            selectedTab: selectedTab,
            time: time,
            strDate: strDate,
            isLoading: isLoading,
            rate: rate,
            strTime: strTime));
      }
      if (event is BoxChooseDate) {
        date = event.index;
        strDate = event.date;
        emit(BoxLoaded(
            selectedTab: selectedTab,
            isLoading: isLoading,
            date: date,
            type: type,
            rate: rate,
            isAvailable: isAvailable,
            time: time,
            strDate: strDate,
            comments: comments,
            strTime: strTime));
      }
      if (event is BoxChooseTime) {
        time = event.index;
        strTime = event.time;
        emit(BoxLoaded(
            selectedTab: selectedTab,
            date: date,
            isAvailable: isAvailable,
            type: type,
            time: time,
            comments: comments,
            rate: rate,
            strDate: strDate,
            isLoading: isLoading,
            strTime: strTime));
      }
      if (event is BoxBook) {
        isLoading = true;
        emit(BoxLoaded(
            date: date,
            rate: rate,
            isAvailable: isAvailable,
            type: type,
            time: time,
            selectedTab: selectedTab,
            strDate: strDate,
            isLoading: isLoading,
            comments: comments,
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
          SharedPreferences prefs = await SharedPreferences.getInstance();

          String userPhone = await PhoneVerification()
              .getUserFieldById(await prefs.getString('id') ?? '', 'phone');
          var userBookings = await PhoneVerification()
              .getUserFieldById(await prefs.getString('id') ?? '', 'booking');
          userBookings.add({
            'box': (lastBox + 1).toString(),
            'date': strDate,
            'time': strTime,
            'washName': userData['name'],
            'washID': event.id,
            'type': type.toString(),
          });

          await PhoneVerification().updateUserFieldById(
              await prefs.getString('id') ?? '', 'booking', userBookings);
          var data = {
            'box': (lastBox + 1).toString(),
            'date': strDate,
            'time': strTime,
            'id': event.id,
            'phone': userPhone,
            'type': type.toString()
          };
          List bookings = userData['booking'];
          bookings.add(data);

          try {
            await documentReference.update({'booking': bookings});
            print("Document successfully updated");
            type = 0;
            date = -1;
            time = -1;
            strTime = '';
            strDate = '';
            isLoading = false;

            emit(BoxBookSuccess());
            emit(BoxLoaded(
                isLoading: isLoading,
                date: date,
                isAvailable: isAvailable,
                comments: comments,
                type: type,
                selectedTab: selectedTab,
                time: time,
                rate: rate,
                strDate: strDate,
                strTime: strTime));
          } catch (e) {
            isLoading = false;
            emit(BoxLoaded(
                isLoading: isLoading,
                date: date,
                rate: rate,
                isAvailable: isAvailable,
                type: type,
                time: time,
                strDate: strDate,
                comments: comments,
                selectedTab: selectedTab,
                strTime: strTime));
            print("Error updating document: $e");
          }
        } else {
          emit(BoxBookBooked());
          isLoading = false;
          emit(BoxLoaded(
              date: date,
              isLoading: isLoading,
              type: type,
              comments: comments,
              selectedTab: selectedTab,
              time: time,
              rate: rate,
              isAvailable: isAvailable,
              strDate: strDate,
              strTime: strTime));
        }
      }
      if (event is BoxChangeTabIndex) {
        selectedTab = event.index;
        emit(BoxLoaded(
            date: date,
            isLoading: isLoading,
            type: type,
            selectedTab: selectedTab,
            time: time,
            rate: rate,
            comments: comments,
            isAvailable: isAvailable,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is BoxChangeRate) {
        rate = event.rate;

        emit(BoxLoaded(
            date: date,
            isLoading: isLoading,
            type: type,
            comments: comments,
            selectedTab: selectedTab,
            time: time,
            rate: rate,
            isAvailable: isAvailable,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is BoxAddComment) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('washes')
            .doc(event.id)
            .get();
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('washes').doc(event.id);
        comments = documentSnapshot['comments'];
        comments.add({
          'name': event.name,
          'comment': event.comment,
          'star': event.rate.toString(),
          'date': DateTime.now()
        });

        await documentReference.update({'comments': comments});
        add(BoxLoad(commentData: comments));
        emit(BoxLoaded(
            date: date,
            isLoading: isLoading,
            type: type,
            comments: comments,
            selectedTab: selectedTab,
            time: time,
            rate: rate,
            isAvailable: isAvailable,
            strDate: strDate,
            strTime: strTime));
      }
      if (event is BoxAddCommentsLocal) {
        comments = event.data;

        log('comments ' + comments.toString());
        emit(BoxLoaded(
            date: date,
            isLoading: isLoading,
            type: type,
            comments: comments,
            selectedTab: selectedTab,
            time: time,
            rate: rate,
            isAvailable: isAvailable,
            strDate: strDate,
            strTime: strTime));
      }
    });
  }
}
