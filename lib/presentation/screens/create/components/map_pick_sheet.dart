import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wash_and_go/presentation/screens/create/bloc/create_bloc.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapPicker {
  final yandexMapController = Completer<YandexMapController>();
  List<MapObject<dynamic>> mapObjects = [];

  Future<void> _moveToLocation(
    location,
  ) async {
    (await yandexMapController.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 2),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
              latitude: double.parse(location.latitude.toString()),
              longitude: double.parse(location.longitude.toString())),
          zoom: 16,
        ),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.requestPermission();
    var coordinate = await Geolocator.getCurrentPosition();
    _moveToLocation(
      coordinate,
    );
  }

  showModalBottomSheetMap(BuildContext context) {
    List res = [];
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      // This prevents the sheet from being dismissed by dragging
      context: context,
      builder: (builder) {
        getCurrentLocation();
        return Stack(children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: MediaQuery.of(context).size.height / 1.2,
            child: YandexMap(
                mapObjects: mapObjects,
                onMapCreated: (controller) {
                  try {
                    yandexMapController.complete(controller);
                  } catch (e) {}
                },
                onCameraPositionChanged: (cameraPosition, reason, finished) {
                  res = [];
                  res.add(cameraPosition.target.latitude);
                  res.add(cameraPosition.target.longitude);
                }),
          ),
          Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.location_searching_outlined)),
          ),
          Positioned.fill(
            bottom: 30,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 14,
                child: Center(
                  child: Text('Выберите место вашего мойки на карте'),
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 30,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 14,
                child: CustomButton(
                    function: () {
                      BlocProvider.of<CreateBloc>(context)
                        ..add(CreateLocationUpdate(data: res));

                      Navigator.pop(context);
                    },
                    title: 'Выбрать'),
              ),
            ),
          ),
        ]);
      },
    );
    return res;
  }
}
