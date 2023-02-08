import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../constants/colors.dart';
import '../constants/shadows.dart';
import '../constants/theme.dart';
import '../utils/marval_arq.dart';
import '../utils/objects/user.dart';
import 'image_editor.dart';

class BoxUserData extends StatelessWidget {
  const BoxUserData({required this.user, Key? key}) : super(key: key);
  final MarvalUser user;
  @override
  Widget build(BuildContext context) {
    return Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  boxShadow: [kMarvalHardShadow],
                  borderRadius: BorderRadius.all(Radius.circular(100.w)),
                ),
                child: CachedNetworkImage(
                  imageUrl: user.profileImage ?? "",
                  imageBuilder: (context, imageProvider) {
                    return GestureDetector(
                        onTap: (){
                          if(isNotNullOrEmpty(user.profileImage)){
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: kBlack,
                                pageBuilder: (BuildContext context, _, __) {
                                  return  FullScreenPage(
                                   dark: true,
                                   url: user.profileImage!,
                                   child: Container(
                                       height: 100.h, width: 100.w,
                                       decoration: BoxDecoration(
                                           image: DecorationImage(
                                               image: imageProvider,
                                               fit: BoxFit.cover
                                  ))));
                                },
                              ),
                            );}},
                        child: CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 6.h,
                        ));
                  },
                  placeholder: (context, url) => _profileImage(),
                  errorWidget: (context, url, error) => _profileImage(),
                ),
            ),
            SizedBox(width: 2.w),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h,),
                  TextH2( '${user.name.removeIcon()} ${user.lastName}'.maxLength(20), size: 4),
                  TextH2( user.work, size: 3, color: kGrey,),
                ])
          ]);
  }
}

class _profileImage extends StatelessWidget {
  const _profileImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 6.h,
        backgroundColor: kBlack,
        child:  Icon(CustomIcons.person, color: kWhite, size: 13.w)
    );
  }
}
