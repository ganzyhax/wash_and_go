import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wash_and_go/domain/entities/washes.dart';

class CarWahserModel extends CarWahserEntity {
  CarWahserModel(
      {required String id,
      required String name,
      required List prices,
      required List<dynamic> booking,
      required String adress,
      required String description,
      required String mainImage,
      required List jobTime,
      required List comments,
      required List images,
      required String washCount,
      required String phone,
      required List location})
      : super(
            id: id,
            name: name,
            phone: phone,
            comments: comments,
            mainImage: mainImage,
            images: images,
            booking: booking,
            prices: prices,
            washCount: washCount,
            jobTime: jobTime,
            description: description,
            location: location,
            adress: adress);

  factory CarWahserModel.fromFirestore(DocumentSnapshot map) {
    return CarWahserModel(
      id: map.id,
      adress: map['adress'],
      washCount: map['washCount'],
      images: map['images'],
      booking: map['booking'],
      jobTime: map['jobTime'],
      phone: map['phone'],
      comments: map['comments'],
      mainImage: map['mainImage'],
      location: map['location'],
      description: map['description'],
      name: map['name'],
      prices: map['prices'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adress': adress,
      'booking': booking,
      'washCount': washCount,
      'images': images,
      'jobTime': jobTime,
      'phone': phone,
      'mainImage': mainImage,
      'comments': comments,
      'location': location,
      'description': description,
      'name': name,
      'prices': prices,
    };
  }
}
