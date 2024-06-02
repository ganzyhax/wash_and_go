import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/domain/entities/washes.dart';

abstract class CarWasherRepository {
  Future<CarWahserEntity> getCarWasher(String id);
  Future<List<CarWahserEntity>> getCarWashers();
  Future<bool> createCarWasher(CarWahserModel model);
}
