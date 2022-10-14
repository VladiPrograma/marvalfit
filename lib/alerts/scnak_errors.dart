import 'package:flutter/material.dart';

import '../widgets/marval_snackbar.dart';


class ThrowSnackbar{

  static void downloadError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: "Ups, algo ha fallado",
        subtitle: "No se ha podido realizar la descarga"
    );
  }

  static void downloadSuccess(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.success,
        title: "Descarga completa!",
        subtitle: "El archivo se ha descargado con exito"
    );
  }

}