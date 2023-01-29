import 'package:flutter/material.dart';
import '../../widgets/marval_snackbar.dart';

//@TODO Hacer los snacks mas largos de 20secs y añadir un boton en la esquina superior derecha para cerrar el  snack.

class ThrowSnackbar{
  //Home
    //Next Week arrow
  static void nextWeekError(BuildContext context){
     MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Esta prohibido viajar al futuro',
        subtitle: r'Lo pasado ha huido, lo que esperas está ausente, pero el presente es tuyo.');
  }

  //Trainings
    //Save Training Error
   static void trainingUpdateError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Ups, algo ha fallado',
        subtitle: r'El entreno no se ha guardado con exito porque uno o varios campos no estaban completos.'
    );
  }

 //Auth
    //Reset Email
  static void resetEmailError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Ops, algo ha salido mal',
        subtitle: r'No hemos podido actualizar tu email, intenta de nuevo mas tarde.');
  }
  static void resetEmailSuccess(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.success,
        title: r'Todo en orden!',
        subtitle: r'Tu correo se ha actualizado con exito');
  }
    //Reset Password
  static void resetPaswordSuccess(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.success,
        title: r'Todo en orden!',
        subtitle: r'La contraseña se ha actualizado, procura que no se te olvide.');
  }
  static void resetPasswordError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Ops, algo ha salido mal',
        subtitle: r'No hemos podido actualizar tu contraseña, intenta de nuevo mas tarde.');

  }
    //Sign up
  static void signUpError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Error al registrar usuario',
        subtitle: r'No se pudo dar de alta al usuario debido a un error inesperado. Prueba de nuevo mas tarde');
  }
  static void signUpAlreadyLoggedError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Error al registrar usuario',
        subtitle: r'El email proporcionado ya se encuentra actualmente registrado en la base de datos');
  }
  static void signUpSuccess(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.success,
        title: r'Usuario registrado con exito',
        subtitle: r'Ya puedes configurar el entrenamiento del usuario.'
    );
  }

  //Habits Page
  static void habitUpdateError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Ups, algo ha fallado',
        subtitle: r'Parece que el habito no se ha podido actualizar, intenta de nuevo mas tarde.'
    );
  }
  static void habitUpdateSuccess(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.success,
        title: r'Habito actualizado! ',
        subtitle: r'Estos cambios se veran reflejados al volver a asignar el habito a cada usuario.'
    );
  }
  static void deleteHabitError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Paso a paso',
        subtitle: r'Primero debes deseleccionar a todos los usuarios'
    );
  }

  // Firebase Storage
      //Images
  static void downloadError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Ups, algo ha fallado',
        subtitle: r'No se ha podido realizar la descarga'
    );
  }
  static void downloadSuccess(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.success,
        title: r'Descarga completa!',
        subtitle: r'El archivo se ha descargado con exito'
    );
  }


  // IMAGES
  static void imageError(BuildContext context){
    MarvalSnackBar(context, SNACKTYPE.alert,
        title: r'Ups, algo ha fallado',
        subtitle: r'No se ha podido seleccionar la imagen'
    );
  }

}