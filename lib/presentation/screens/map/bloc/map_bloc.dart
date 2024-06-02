import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/data/datasource/car_washer_remote_datasource.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/data/repositories/car_washer_repository_impl.dart';
import 'package:wash_and_go/domain/entities/washes.dart';
import 'package:wash_and_go/domain/usecases/get_car_washer.dart';
import 'dart:math' show asin, cos, pow, sqrt;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<MapEvent>((event, emit) async {
      CarWasherRepositoryImpl repository = CarWasherRepositoryImpl(
        remoteDataSource: GetCarWasherRemoteDataSourceImpl(),
      );
      if (event is MapLoad) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        double calculateDistance(
            double lat1, double lon1, double lat2, double lon2) {
          const p = 0.017453292519943295;
          final c = cos;
          final a = 0.5 -
              c((lat2 - lat1) * p) / 2 +
              c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
          return 12742 * asin(sqrt(a));
        }

        List<CarWahserEntity> sortCarWashersByDistance(
            List<CarWahserEntity> carWashers,
            double myLocation1,
            double myLocation2) {
          carWashers.sort((a, b) {
            double distanceA = calculateDistance(
                myLocation1,
                myLocation2,
                double.parse(a.location[0].toString()),
                double.parse(a.location[1].toString()));
            double distanceB = calculateDistance(
                myLocation1,
                myLocation2,
                double.parse(b.location[0].toString()),
                double.parse(b.location[1].toString()));
            return distanceA.compareTo(distanceB);
          });
          return carWashers;
        }

        List<String>? myLocation = prefs.getStringList('location');

        final data =
            await CarWasher(carWasherRepository: repository).getAllCarWashers();

        List<CarWahserEntity> sortedCarWashers = sortCarWashersByDistance(
            data,
            double.parse(myLocation![0].toString()),
            double.parse(myLocation[1].toString()));
        print(sortedCarWashers);
        emit(MapLoaded(washes: sortedCarWashers));
      }
    });
  }
}
