class CarWahserEntity {
  String id;
  final String name;
  final List prices;
  final String adress;
  final String description;
  final List location;
  final String mainImage;
  final List images;
  final String washCount;
  final String phone;
  final List comments;
  final List<dynamic> booking;
  final List jobTime;
  CarWahserEntity({
    required this.name,
    required this.id,
    required this.comments,
    required this.washCount,
    required this.phone,
    required this.images,
    required this.jobTime,
    required this.prices,
    required this.booking,
    required this.adress,
    required this.mainImage,
    required this.description,
    required this.location,
  });
}
