part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoaded extends MapState {
  List<CarWahserEntity> washes;
  MapLoaded({required this.washes});
}

final class MapAddLWashLocation extends MapState {
  CarWahserModel wahserModel;
  MapAddLWashLocation({required this.wahserModel});
}
