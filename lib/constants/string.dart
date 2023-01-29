
const String h1 = 'RedHatBlack';
const String h2 = 'RedHatBold';

const String p1 = 'RedHatMedium';
const String p2 = 'RedHatRegular';


/// Error message displayed on InputFields
const String kEmptyValue = 'Campo requerido.';
const String kEmailMissmatch ='El correo indicado no existe.';
const String kEmail ='El correo no ha sido dado de alta.';

const String kToLong ='Maximo de caracteres alcanzado.';
const String kPhone ='El telefono no existe.';
const String kNotNum ='Introduzca un numero valido.';

const String kPassword ='Contraseña Incorrecta. Vuelve a intentarlo.';
const String kMin8 ='Debe tener un minimo de 8 caracteres.';
const String kContainsDigit ='Debe contener al menos 1 digito.';


/// Reset Password Messages
const String kResetPasswordSuccesTitle = 'Email en camino!';
const String kResetPasswordSucessSubtitle = 'El correo se ha enviado con exito, consulte su bandeja de entrada.';
const String kResetPasswordErrorTitle = 'Fallo en el envio del correo.';
const String kResetPasswordErrorSubtitle = 'El correo indicado no esta dado de alta.';

/// BD String constants
const String userID = 'USERID_000';

/// Log ASCII Line Art
const String logSuccessPrefix = ":.:.:.:.:.: ";
const String logErrorPrefix = "(__!!!__) --> ";

///Form Constants
const String kSpecifyText = 'Especifica cual, luego pulsa en si';

class ErrorText{
  late String text;
  ErrorText( this.text);
  ErrorText.emptyValue():text = 'Se requiere completar el campo.';

  @override
  String toString(){
    return text;
  }

}




