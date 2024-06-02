import 'package:wash_and_go/domain/entities/washes.dart';
import 'package:wash_and_go/domain/repositories/car_washer_repository.dart';

class CarWasher {
  final CarWasherRepository carWasherRepository;
  CarWasher({required this.carWasherRepository});
  Future<CarWahserEntity> getSingleCarWasher(String id) async {
    return await carWasherRepository.getCarWasher(id);
  }

  Future<List<CarWahserEntity>> getAllCarWashers() async {
    return await carWasherRepository.getCarWashers();
  }
}
