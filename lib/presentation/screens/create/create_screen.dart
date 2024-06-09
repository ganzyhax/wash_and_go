import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_and_go/presentation/screens/create/bloc/create_bloc.dart';
import 'package:wash_and_go/presentation/screens/create/components/image_add_card.dart';
import 'package:wash_and_go/presentation/screens/create/components/map_pick_sheet.dart';
import 'package:wash_and_go/presentation/screens/create/components/web_map_pick_sheet.dart';
import 'package:wash_and_go/presentation/widgets/buttons/custom_button.dart';
import 'package:wash_and_go/presentation/widgets/fields/custom_textfiled.dart';

class WashCreateScreen extends StatefulWidget {
  const WashCreateScreen({super.key});

  @override
  State<WashCreateScreen> createState() => _WashCreateScreenState();
}

class _WashCreateScreenState extends State<WashCreateScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController adress = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController price1 = TextEditingController();
  TextEditingController price2 = TextEditingController();
  TextEditingController price3 = TextEditingController();
  TextEditingController washCount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Создать мойку'),
      ),
      body: BlocBuilder<CreateBloc, CreateState>(
        builder: (context, state) {
          if (state is CreateLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, right: 20, left: 20, bottom: 120),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Important to prevent column stretching

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: ImageAddCard(
                      image:
                          (state.images.length == 0) ? null : state.images[0],
                      isLarge: true,
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageAddCard(
                          isLarge: false,
                          image: (state.images.length <= 1)
                              ? null
                              : state.images[1],
                        ),
                        ImageAddCard(
                          isLarge: false,
                          image: (state.images.length <= 2)
                              ? null
                              : state.images[2],
                        ),
                        ImageAddCard(
                          isLarge: false,
                          image: (state.images.length <= 3)
                              ? null
                              : state.images[3],
                        ),
                        ImageAddCard(
                          isLarge: false,
                          image: (state.images.length <= 4)
                              ? null
                              : state.images[4],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            controller: name, hintText: 'Название мойки')),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            controller: description,
                            hintText: 'Описание мойки')),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            controller: phone, hintText: 'Номер для связи')),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            controller: adress, hintText: 'Адрес мойки')),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Локация работы',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (state.location.length != 0)
                        ? Row(
                            children: [
                              Text(
                                'Локация: ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                state.location[0].toString() +
                                    ' , ' +
                                    state.location[1].toString(),
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                        TextButton(
                            onPressed: () async {
                              (!kIsWeb)
                                  ? await YandexMapPicker()
                                      .showModalBottomSheetMap(context)
                                  : await WebMapPicker()
                                      .showModalBottomSheetMap(context);
                            },
                            child: Text('Выбрать локацию'))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Режим работы',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () async {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              BlocProvider.of<CreateBloc>(context)
                                ..add(CreateTimeStartPick(date: pickedTime));
                            },
                            child: Text(
                              state.times[0],
                              style: TextStyle(fontSize: 18),
                            )),
                        Text('-'),
                        TextButton(
                            onPressed: () async {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              BlocProvider.of<CreateBloc>(context)
                                ..add(CreateTimeEndPick(date: pickedTime));
                            },
                            child: Text(
                              state.times[1],
                              style: TextStyle(fontSize: 18),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            isNumber: true,
                            controller: price1,
                            hintText: 'Цена для седан')),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            isNumber: true,
                            controller: price2,
                            hintText: 'Цена для кроссовер')),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            isNumber: true,
                            controller: price3,
                            hintText: 'Цена для пикап')),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: CustomTextField(
                            isNumber: true,
                            controller: washCount,
                            hintText: 'Количество боксов')),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        isLoading: state.isLoading,
                        function: () {
                          BlocProvider.of<CreateBloc>(context)
                            ..add(CreateFinish(
                                context: context,
                                name: name.text,
                                description: description.text,
                                adress: adress.text,
                                phone: phone.text,
                                price1: price1.text,
                                price2: price2.text,
                                price3: price3.text,
                                washCount: washCount.text));
                        },
                        title: 'Создать')
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
