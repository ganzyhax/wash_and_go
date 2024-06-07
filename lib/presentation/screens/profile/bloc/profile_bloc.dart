import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileLoad) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = await PhoneVerification()
            .getUserFieldById(prefs.getString('id') ?? '', 'booking');
        print(data);
        emit(ProfileLoaded(data: data));
      }
    });
  }
}
