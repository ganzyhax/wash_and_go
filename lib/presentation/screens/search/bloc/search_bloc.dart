import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wash_and_go/data/datasource/car_washer_remote_datasource.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/data/repositories/car_washer_repository_impl.dart';
import 'package:wash_and_go/domain/entities/washes.dart';
import 'package:wash_and_go/domain/usecases/get_car_washer.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      CarWasherRepositoryImpl repository = CarWasherRepositoryImpl(
        remoteDataSource: GetCarWasherRemoteDataSourceImpl(),
      );
      if (event is SearchLoad) {
        final data =
            await CarWasher(carWasherRepository: repository).getAllCarWashers();
        emit(SearchLaoded(washes: data));
      }
    });
  }
}
