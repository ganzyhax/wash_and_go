import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_and_go/data/model/wash_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wash_and_go/presentation/screens/login/functions/auth.dart';

abstract class CarWasherRemoteDataSource {
  Future<CarWahserModel> getCarWasher(String id);
  Future<bool> updateCarWasher(CarWahserModel model);
  Future<List<CarWahserModel>> getCarWashers();
  Future<bool> createCarWasher(CarWahserModel carWahserModel);
}

class GetCarWasherRemoteDataSourceImpl implements CarWasherRemoteDataSource {
  GetCarWasherRemoteDataSourceImpl();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<CarWahserModel> getCarWasher(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc = await firestore.collection('washes').doc(id).get();

    return CarWahserModel.fromFirestore(doc);
  }

  Future<List<CarWahserModel>> getCarWashers() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('washes').get();
    List<CarWahserModel> washers = querySnapshot.docs.map((doc) {
      return CarWahserModel.fromFirestore(doc);
    }).toList();

    return washers;
  }

  Future<bool> updateCarWasher(CarWahserModel model) async {
    try {
      final CollectionReference washes =
          FirebaseFirestore.instance.collection('washes');

      DocumentReference documentRef = washes.doc(model.id);

      await documentRef.set(model
          .toMap()); // Assuming toMap() converts the CarWahserModel to a Map

      return true;
    } catch (e) {
      print('Error updating car washer: $e');
      return false;
    }
  }

  Future<bool> createCarWasher(CarWahserModel model) async {
    try {
      final CollectionReference washes =
          FirebaseFirestore.instance.collection('washes');
      DocumentReference documentRef = washes.doc();
      model.id = documentRef.id;
      await documentRef.set(model.toMap());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await PhoneVerification().updateUserFieldById(
          prefs.getString('id') ?? '', 'washerId', documentRef.id);
      await prefs.setBool('isWashCreated', true);
      return true;
    } catch (e) {
      return false;
    }
  }
}
