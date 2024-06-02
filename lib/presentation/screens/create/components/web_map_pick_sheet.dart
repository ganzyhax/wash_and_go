import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wash_and_go/presentation/screens/create/bloc/create_bloc.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class WebMapPicker {
  final yandexMapController = Completer<YandexMapController>();
  List<MapObject<dynamic>> mapObjects = [];
  MapController controller = MapController();
  void _moveToCurrentLocation(location) {
    if (location != null) {
      controller.move(
        LatLng(location.latitude, location.longitude),
        15.0,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    await Geolocator.requestPermission();

    var coordinate = await Geolocator.getCurrentPosition();
    _moveToCurrentLocation(
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
            child: FlutterMap(
              mapController: controller,
              options: MapOptions(
                onPositionChanged: (position, hasGesture) {
                  res = [];
                  res.add(position.center!.latitude);
                  res.add(position.center!.longitude);
                },
                initialCenter: LatLng(51.5, -0.09),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  tileProvider: NetworkTileProvider(),
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
              ],
            ),
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
