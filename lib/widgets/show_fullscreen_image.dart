import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors.dart';
import 'image_editor.dart';

//@OPTIONAL Icon Animation when download button is pressedd
class FullScreenImage extends StatelessWidget {
  const FullScreenImage({this.child, required this.url, required this.image, Key? key}) : super(key: key);
  final String url;
  final ImageProvider image;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              PageRouteBuilder(
                  opaque: false,
                  barrierColor: kWhite,
                  pageBuilder: (BuildContext context, _, __) {
                    return FullScreenPage(
                        dark: true,
                        url: url,
                        child: Container(
                            height: 100.h, width: 100.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: image,
                                    fit: BoxFit.contain
                                ))));
                  }));},
        child: child ??
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    )))
    );
  }
}
