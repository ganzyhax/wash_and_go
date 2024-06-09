import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:wash_and_go/data/datasource/car_washer_remote_datasource.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:wash_and_go/data/repositories/car_washer_repository_impl.dart';
import 'package:wash_and_go/presentation/screens/main_navigator/bloc/main_navigator_bloc.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  File? _image;

  EditBloc() : super(EditInitial()) {
    List images = [];
    List times = ['00:00', '00:00'];
    List location = [];
    var data;
    bool isLoading = false;
    CarWasherRepositoryImpl repository = CarWasherRepositoryImpl(
      remoteDataSource: GetCarWasherRemoteDataSourceImpl(),
    );
    on<EditEvent>((event, emit) async {
      if (event is EditLoad) {
        data = await repository.getCarWasher(event.id);
        CarWahserModel datas = data;
        location = datas.location;
        times = datas.jobTime;
        images = datas.images;
        emit(EditLoaded(
            images: images,
            times: times,
            data: data,
            location: location,
            isLoading: isLoading));
      }
      if (event is EditImageAdd) {
        if (!kIsWeb) {
          final pickedFile =
              await ImagePicker().pickImage(source: ImageSource.gallery);

          if (pickedFile != null) {
            _image = File(pickedFile.path);
            images.add(_image);
          } else {
            print('No image selected.');
          }
          emit(EditLoaded(
              images: images,
              times: times,
              data: data,
              location: location,
              isLoading: isLoading));
        } else {
          FirebaseStorage storage = FirebaseStorage.instance;

          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowMultiple: false,
            onFileLoading: (FilePickerStatus status) => print(status),
            allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
          );

          if (result != null && result.files.isNotEmpty) {
            final uint8List = result.files.first.bytes;
            final Reference storageReference =
                storage.ref().child('images/${DateTime.now()}.jpg');

            final UploadTask uploadTask = storageReference.putData(uint8List!);
            await uploadTask.whenComplete(() {});

            final String downloadUrl = await storageReference.getDownloadURL();
            images.add(downloadUrl);
            emit(EditLoaded(
                images: images,
                times: times,
                data: data,
                location: location,
                isLoading: isLoading));
          }
        }
      }
      if (event is EditTimeStartPick) {
        String minute = event.date.minute.toString();
        String hour = event.date.hour.toString();
        if (event.date.minute < 10) {
          minute = '0' + event.date.minute.toString();
        }
        if (event.date.hour < 10) {
          hour = '0' + event.date.hour.toString();
        }
        times[0] = hour + ':' + minute;

        emit(EditLoaded(
            data: data,
            images: images,
            times: times,
            location: location,
            isLoading: isLoading));
      }

      if (event is EditTimeEndPick) {
        String minute = event.date.minute.toString();
        String hour = event.date.hour.toString();
        if (event.date.minute < 10) {
          minute = '0' + event.date.minute.toString();
        }
        if (event.date.hour < 10) {
          hour = '0' + event.date.hour.toString();
        }
        times[1] = hour + ':' + minute;
        emit(EditLoaded(
            images: images,
            times: times,
            data: data,
            location: location,
            isLoading: isLoading));
      }
      if (event is EditLocationUpdate) {
        location = event.data;
        location[0] = double.parse(location[0].toString()).toStringAsFixed(6);
        location[1] = double.parse(location[1].toString()).toStringAsFixed(6);
        emit(EditLoaded(
            images: images,
            data: data,
            times: times,
            location: location,
            isLoading: isLoading));
      }
      if (event is EditFinish) {
        isLoading = true;
        List urlImage = [];
        emit(EditLoaded(
            images: images,
            times: times,
            data: data,
            location: location,
            isLoading: isLoading));
        if (!kIsWeb) {
          urlImage = await uploadImages(images);
        } else {
          urlImage = images;
        }
        CarWahserModel datas = data;

        CarWahserModel model = CarWahserModel(
            adress: event.adress,
            washCount: event.washCount,
            comments: datas.comments,
            phone: event.phone,
            booking: datas.booking,
            jobTime: times,
            prices: [event.price1, event.price2, event.price3],
            name: event.name,
            id: event.id,
            description: event.description,
            images: urlImage,
            mainImage: urlImage[0],
            location: location);
        final bool isSuccess = await repository.updateCarWasher(model);

        isLoading = false;
        emit(EditLoaded(
            images: images,
            times: times,
            location: location,
            data: data,
            isLoading: isLoading));
      }
    });
  }
  Future<List> uploadImages(images) async {
    if (images == null) return [];
    List<String> resImages = [];
    for (var image in images) {
      try {
        if (image.runtimeType != String) {
          File file = File(image.path);
          String fileName = basename(image.path);
          print('good1');
          FirebaseStorage storage = FirebaseStorage.instance;
          print('good2');
          Reference ref = storage.ref().child('uploads/$fileName');
          print('good3');

          // Upload the file
          UploadTask uploadTask = ref.putFile(file);
          print('good4');
          // Optional: if you want to get the download URL
          final TaskSnapshot downloadUrl = (await uploadTask);

          final String url = await downloadUrl.ref.getDownloadURL();
          resImages.add(url);
          print("Download URL: $url");
        } else {
          resImages.add(image);
        }
      } catch (e) {
        print(e); // Handle errors
      }
    }
    return resImages;
  }
}
