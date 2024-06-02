import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wash_and_go/domain/entities/washes.dart';

class StationWidget extends StatelessWidget {
  final CarWahserEntity data;
  const StationWidget({required this.data});
  @override
  Widget build(BuildContext context) {
    double totalStar = 0;
    for (var i = 0; i < data.comments.length; i++) {
      totalStar = totalStar + double.parse(data.comments[i]['star']);
    }
    totalStar = totalStar / data.comments.length;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white, // Placeholder for the gradient
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  bottomLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
                child: Image.network(
                  data.mainImage, // Replace with your image URL
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                (totalStar.toString() == 'NaN')
                                    ? '0.0'
                                    : totalStar.toStringAsFixed(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "📍 " + data.adress,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "📞 " + data.phone,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Book now action
              //     },
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.deepPurple,
              //       onPrimary: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(18.0),
              //       ),
              //     ),
              //     child: Text('Book now'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
