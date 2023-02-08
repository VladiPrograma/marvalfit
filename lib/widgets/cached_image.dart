import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/widgets/show_fullscreen_image.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../constants/colors.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({required this.url, required this.size,  this.expandable,  Key? key}) : super(key: key);
  final String? url;
  final double size;
  final bool? expandable;
  @override
  Widget build(BuildContext context) {
    if(isNullOrEmpty(url)){
      return _Placeholder(size: size);
    }
    return CachedNetworkImage(
        imageUrl: url!,
        fadeInCurve: Curves.easeInBack,
        imageBuilder: (context, imageProvider) {
          if((expandable ?? false) && isNotNullOrEmpty(url)){
            return FullScreenImage(url: url!, image: imageProvider,
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                  backgroundColor: kBlack,
                  radius: size.h,
                ));
          }
          return Container( width: size.h, height: size.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain
              )
            ),
          );
        },
        placeholder: (context, url) => _Placeholder(size: size),
        errorWidget: (context, url, error) => _Placeholder(size: size)
    );
  }
}
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size, Key? key}) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return  SizedBox( width: size.h, height: size.h,
      child: const Center(child: CircularProgressIndicator(color: kBlack),),
    );
  }
}



