import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/firebase_options.dart';
import 'package:wash_and_go/presentation/screens/create/bloc/create_bloc.dart';
import 'package:wash_and_go/presentation/screens/login/login_screen.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/bloc/main_navigator_bloc.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/main_navigator.dart';
import 'package:wash_and_go/presentation/screens/map/bloc/map_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wash_and_go/presentation/screens/profile/bloc/profile_bloc.dart';
import 'package:wash_and_go/presentation/screens/search/bloc/search_bloc.dart';
import 'package:wash_and_go/presentation/screens/statistics/bloc/statistics_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition();
  prefs.setStringList('location',
      [position.longitude.toString(), position.latitude.toString()]);

  String userId = prefs.getString('id') ?? '';
  runApp(MyApp(
    userId: userId,
  ));
}

class MyApp extends StatelessWidget {
  final String userId;
  const MyApp({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainNavigatorBloc()..add(MainNavigatorLoad()),
        ),
        BlocProvider(
          create: (context) => MapBloc()..add(MapLoad()),
        ),
        BlocProvider(
          create: (context) => CreateBloc()..add(CreateLoad()),
        ),
        // BlocProvider(
        //   create: (context) => BoxBloc()..add(BoxLoad()),
        // ),
        BlocProvider(
          create: (context) => SearchBloc()..add(SearchLoad()),
        ),

        BlocProvider(
          create: (context) => StatisticsBloc()..add(StatisticsLoad()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc()..add(ProfileLoad()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: (userId != '') ? CustomNavigationBar() : LoginScreen(),
      ),
    );
  }
}
