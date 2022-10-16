import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:sizer/sizer.dart';

import '../alerts/scnak_errors.dart';
import 'marval_snackbar.dart';

class ImageFullScreenWrapperWidget extends StatelessWidget {
  final Image child;
  final String url;
  final bool dark;

  ImageFullScreenWrapperWidget({
    required this.child,
    required this.url,
    this.dark = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            barrierColor: dark ? Colors.black : Colors.white,
            pageBuilder: (BuildContext context, _, __) {
              return FullScreenPage(
                child: child,
                dark: dark,
                url: url,
              );
            },
          ),
        );
      },
      child: child,
    );
  }
}

class FullScreenPage extends StatefulWidget {
  const FullScreenPage({Key? key,
    required this.child,
    required this.url,
    required this.dark,
  }) : super(key: key);

  final Widget child;
  final String url;
  final bool dark;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  @override
  void initState() {
    var brightness = widget.dark ? Brightness.light : Brightness.dark;
    var color = widget.dark ? Colors.black12 : Colors.white70;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      statusBarColor: color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarDividerColor: color,
      systemNavigationBarIconBrightness: brightness,
    ));
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // Restore your settings here...
    ));
    super.dispose();
  }
  IconData _downloaded = Icons.download_rounded;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 333),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: InteractiveViewer(
                  panEnabled: true,
                  constrained: false,
                  minScale: 0.5,
                  maxScale: 4,
                  child: widget.child,
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
            padding: EdgeInsets.all(3.w),
              child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  MaterialButton(
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: widget.dark ? Colors.black12 : Colors.white70,
                    highlightElevation: 0,
                    minWidth: double.minPositive,
                    height: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child:  Icon(
                      Icons.arrow_back,
                      color: widget.dark ? Colors.white : Colors.black,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w,),
                  MaterialButton(
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: widget.dark ? Colors.black12 : Colors.white70,
                    highlightElevation: 0,
                    minWidth: double.minPositive,
                    height: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () async{
                      if(_downloaded != Icons.download_done_rounded){
                      setState(() {
                        _downloaded = Icons.downloading_rounded;
                      });
                      ImageDownloader.downloadImage(widget.url)
                        .onError((error, stackTrace) {
                           logError(stackTrace.toString());
                           ThrowSnackbar.downloadError(this.context);
                           setState(() => _downloaded = Icons.download_rounded );
                           return null;
                        }).then((value){
                          ThrowSnackbar.downloadSuccess(this.context);
                          setState(() => _downloaded = Icons.download_done_rounded );
                        });

                    }},
                    child: Icon(
                      _downloaded,
                      color: widget.dark ? Colors.white : Colors.black,
                      size: 5.w,
                    ),
                  )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}