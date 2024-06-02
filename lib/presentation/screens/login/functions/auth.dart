import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneVerification {
  final String apiKey =
      'kzff7e39f70c4780fb84cf85e6ee93a92de9bbe56d2aa095bc2d12efca0c183315ff94';
  Future<bool> sendVerificationCode(
      {String? phoneNumber,
      String? generatedCode,
      BuildContext? context}) async {
    bool isBalance = await checkBalance();
    if (isBalance) {
      final response = await http.post(
        Uri.parse(
            'https://api.mobizon.kz/service/message/sendsmsmessage?recipient=$phoneNumber&text=Wash and Go ваш код - $generatedCode&apiKey=$apiKey'),
      );
      var decodedResponse = jsonDecode(response.body);

      if (decodedResponse['code'] == 0) {
        return true;
      } else {
        if (decodedResponse['data']['recipient'] ==
            'На данное направление отправка запрещена.') {
          // AppToast.center('Не правильный номер телефона!');
        } else {
          // AppToast.center('Ошибка сервера!');
        }
        return false;
      }
    } else {
      // AppToast.center('Ошибка сервера!');
      return false;
    }
  }

  Future<bool> checkBalance() async {
    final response = await http.post(
      Uri.parse(
          'https://api.mobizon.kz/service/user/getownbalance?output=json&api=v1&apiKey=$apiKey'),
    );
    var decodedResponse = jsonDecode(response.body);
    print(decodedResponse);
    if (double.parse(decodedResponse['data']['balance'].toString()) > 19) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getUserIdByPhoneNumber(String phoneNumber) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot querySnapshot =
          await users.where('phone', isEqualTo: phoneNumber).get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        // Phone number exists
        return documents
            .first.id; // Return the document ID of the first matching user
      } else {
        // Phone number does not exist
        return null;
      }
    } catch (e) {
      print("Error fetching user ID: $e");
      return null; // Return null in case of error
    }
  }

  Future<String?> createUserWithAutoId(String phoneNumber, bool isCreater,
      String password, String name, String surname, String carNumber) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    try {
      DocumentReference documentRef = users.doc();

      await documentRef.set({
        'id': documentRef.id,
        'phone': phoneNumber,
        'washerId': '',
        'password': password,
        'isCreater': isCreater,
        'booking': [],
        'name': name,
        'surname': surname,
        'carNumber': carNumber,
      });

      return documentRef.id;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getUserFieldById(String userId, String fieldName) async {
    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      DocumentSnapshot documentSnapshot = await userDocRef.get();

      if (documentSnapshot.exists) {
        // Return the specified field value
        return documentSnapshot.get(fieldName);
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting user field: $e');
      return null;
    }
  }

  Future<void> updateUserFieldById(
      String userId, String fieldName, dynamic newValue) async {
    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      await userDocRef.update({
        fieldName: newValue,
      });

      print('Field $fieldName updated successfully for user $userId');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  Future<dynamic> getWasherById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('washes').doc(id).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<String?> login(String phone, String pass) async {
    // Perform the query to find the user document
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .where('password', isEqualTo: pass)
        .get();

    // Check if there's any matching document
    if (querySnapshot.docs.isNotEmpty) {
      // If there is, return the document ID of the first matching document
      return querySnapshot.docs.first.id;
    } else {
      // If no matching document found, return null
      return null;
    }
  }
}
