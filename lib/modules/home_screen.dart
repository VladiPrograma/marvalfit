import 'package:flutter/material.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:sizer/sizer.dart';

import '../constants/theme.dart';
import '../widgets/marval_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

///@TODO Get User data when is Already Logged.
///@TODO Main page Logic when is Logged but he doesnt complete de forms.

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MarvalDrawer(name: "Home",),
      backgroundColor: kWhite,
      body: SafeArea(
        child: Container( width: 100.w, height: 100.h,
        child: const Center(child: TextH2('HOME'))),
      ),
    );
  }
}


