import 'package:wash_and_go/data/datasource/car_washer_remote_datasource.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/domain/repositories/car_washer_repository.dart';

class CarWasherRepositoryImpl implements CarWasherRepository {
  final CarWasherRemoteDataSource remoteDataSource;
  CarWasherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CarWahserModel> getCarWasher(String id) async {
    CarWahserModel carWahserModel = await remoteDataSource.getCarWasher(id);
    return carWahserModel;
  }

  Future<List<CarWahserModel>> getCarWashers() async {
    List<CarWahserModel> carWahserModel =
        await remoteDataSource.getCarWashers();
    return carWahserModel;
  }

  Future<bool> createCarWasher(CarWahserModel model) async {
    bool isSuccess = await remoteDataSource.createCarWasher(model);
    return isSuccess;
  }

  Future<bool> updateCarWasher(CarWahserModel model) async {
    bool isSuccess = await remoteDataSource.updateCarWasher(model);
    return isSuccess;
  }
}
