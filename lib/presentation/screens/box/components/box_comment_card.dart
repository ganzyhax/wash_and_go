import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoxCommentCard extends StatelessWidget {
  final data;
  const BoxCommentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    try {
      DateTime dateTime = data['date'].toDate();
      formattedDate = DateFormat('dd MMMM HH:mm').format(dateTime);
    } catch (e) {
      formattedDate = DateFormat('dd MMMM HH:mm').format(DateTime.now());
    }
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10,
                ),
                buildRatingStars(double.parse(data['star'])),
              ],
            ),
            Text(formattedDate),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(data['comment']),
      ]),
    );
  }

  Widget buildRatingStars(double rating) {
    int numberOfFullStars = rating.floor();
    double remainder = rating - numberOfFullStars;
    List<Widget> stars = [];

    // Add full stars
    for (int i = 0; i < numberOfFullStars; i++) {
      stars.add(Icon(
        Icons.star,
        size: 18,
        color: Colors.yellow,
      ));
    }

    // Add half star if necessary
    if (remainder >= 0.5) {
      stars.add(Icon(
        Icons.star_half,
        size: 18,
        color: Colors.yellow,
      ));
    }

    // Add empty stars to fill the row
    int numberOfEmptyStars = 5 - stars.length;
    for (int i = 0; i < numberOfEmptyStars; i++) {
      stars.add(Icon(
        Icons.star_border,
        size: 18,
        color: Colors.yellow,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: stars,
    );
  }
}
