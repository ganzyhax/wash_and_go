import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_and_go/presentation/screens/create/bloc/create_bloc.dart';

class ImageAddCard extends StatelessWidget {
  final bool? isLarge;
  final Function()? function;
  final image;
  const ImageAddCard({
    super.key,
    this.isLarge = false,
    this.function,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function ??
          () {
            BlocProvider.of<CreateBloc>(context)..add(CreateImageAdd());
          },
      child: Container(
        width: (isLarge == true)
            ? MediaQuery.of(context).size.width / 1
            : MediaQuery.of(context).size.width / 5,
        height: (isLarge == true)
            ? MediaQuery.of(context).size.height / 4
            : MediaQuery.of(context).size.height / 12,
        child: (image == null)
            ? Center(
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.grey[300],
                  size: (isLarge == true) ? 100 : 40,
                ),
              )
            : (image!.toString().contains('https'))
                ? Image.network(image!.toString())
                : Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey[200]),
      ),
    );
  }
}
