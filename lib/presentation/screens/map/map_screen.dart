import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/domain/entities/washes.dart';
import 'package:wash_and_go/presentation/screens/box/box_page.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/bloc/main_navigator_bloc.dart';
import 'package:wash_and_go/presentation/screens/map/bloc/map_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PageController pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 0.8);
  final yandexMapController = Completer<YandexMapController>();
  List<MapObject<dynamic>> mapObjects = [];
  Future<void> getCurrentLocation() async {
    await Geolocator.requestPermission();
    var coordinate = await Geolocator.getCurrentPosition();

    _moveToCurrentLocation(
      coordinate,
    );
  }

  addWasherLocation(CarWahserEntity data, id) {
    final washerLocation = PlacemarkMapObject(
      mapId: MapObjectId('washerLocation/' + id.toString()),
      opacity: 1,
      onTap: (a, as) {
        pageController.animateToPage(
            int.parse(a.mapId.value.split('/')[1].toString()),
            duration: Duration(milliseconds: 700),
            curve: Curves.ease);
        ;
      },
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            scale: 1.2,
            rotationType: RotationType.rotate,
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/my_location_logo.png',
            )),
      ),
      point: Point(
          latitude: double.parse(data.location[0].toString()),
          longitude: double.parse(data.location[1].toString())),
    );
    mapObjects.add(washerLocation);
    setState(() {});
  }

  Future<void> _moveToLocation(
    location,
  ) async {
    (await yandexMapController.future).moveCamera(
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 2,
      ),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
              latitude: double.parse(location[0].toString()),
              longitude: double.parse(location[1].toString())),
          zoom: 16,
        ),
      ),
    );
  }

  Future<void> _moveToCurrentLocation(
    location,
  ) async {
    (await yandexMapController.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 2),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              Point(latitude: location.latitude, longitude: location.longitude),
          zoom: 16,
        ),
      ),
    );
    final myLocationMarker = PlacemarkMapObject(
      mapId: const MapObjectId('myLocation'),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            scale: 1,
            rotationType: RotationType.rotate,
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/user_location.png',
            )),
      ),
      point: Point(latitude: location.latitude, longitude: location.longitude),
    );
    mapObjects.add(myLocationMarker);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getCurrentLocation().ignore();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc()..add(MapLoad()),
      child: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoaded) {
            for (var i = 0; i < state.washes.length; i++) {
              addWasherLocation(state.washes[i], i);
            }
          }
        },
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapLoaded) {
              return Scaffold(
                body: Stack(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    decoration: const BoxDecoration(color: Colors.deepPurple),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                child: Text(
                                  'Kazakhstan',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: YandexMap(
                          mapObjects: mapObjects,
                          onMapCreated: (controller) {
                            try {
                              yandexMapController.complete(controller);
                            } catch (e) {
                              yandexMapController.complete(controller);
                            }
                          },
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 160,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RawMaterialButton(
                        onPressed: () async {
                          await getCurrentLocation();
                        },
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                        shape: const CircleBorder(),
                        child: const Icon(
                          CupertinoIcons.location_fill,
                        ),
                      ),
                    ),
                  ),
                  (state.washes.length != 0)
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 110.0),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 4.3,
                                child: PageView.builder(
                                  itemCount: state.washes.length,
                                  scrollDirection: Axis.horizontal,
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    _moveToLocation(
                                        state.washes[index].location);
                                  },
                                  itemBuilder: (context, index) {
                                    double totalStar = 0;
                                    for (var i = 0;
                                        i < state.washes[index].comments.length;
                                        i++) {
                                      totalStar = totalStar +
                                          double.parse(state.washes[index]
                                              .comments[i]['star']);
                                    }
                                    totalStar = totalStar /
                                        state.washes[index].comments.length;

                                    print(state.washes[index].comments);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, right: 12),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => BoxScreen(
                                                      wash: state.washes[index],
                                                      title: state
                                                          .washes[index].name,
                                                    )),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: FadeInImage(
                                                    placeholder: AssetImage(
                                                        'assets/images/placeholder.png'),
                                                    image: NetworkImage(state
                                                        .washes[index]
                                                        .mainImage),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              top: 130,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(55),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      spreadRadius: 3,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      7,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.035,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      color: Colors.white),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        size: 20,
                                                        color: Colors.amber,
                                                      ),
                                                      Text(
                                                        (totalStar.toString() ==
                                                                'NaN')
                                                            ? '0.0'
                                                            : totalStar
                                                                .toStringAsFixed(
                                                                    1),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        state
                                                            .washes[index].name,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            color: Colors
                                                                .grey[200],
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            state.washes[index]
                                                                .adress,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[200],
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )),
                        )
                      : SizedBox()
                ]),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
