import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/widgets/show_fullscreen_image.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../constants/colors.dart';

class CachedAvatarImage extends StatelessWidget {
  const CachedAvatarImage({required this.url, required this.size,  this.expandable,  Key? key}) : super(key: key);
  final String? url;
  final double size;
  final bool? expandable;
  @override
  Widget build(BuildContext context) {

    if(isNullOrEmpty(url)){
      return _CircleAvatarIcon(size: size);
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
        return CircleAvatar(
          backgroundImage: imageProvider,
          backgroundColor: kBlack,
          radius: size.h,
        );
      },
      placeholder: (context, url) => _CircleAvatarIcon(size: size),
      errorWidget: (context, url, error) => _CircleAvatarIcon(size: size)
    );
  }
}
class _CircleAvatarIcon extends StatelessWidget {
  const _CircleAvatarIcon({required this.size, Key? key}) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
        radius: size.h,
        backgroundColor: kBlack,
        child: Icon(CustomIcons.person, color: kGrey, size: (size+3).w,)
    );
  }
}



