
const String h1 = 'RedHatBlack';
const String h2 = 'RedHatBold';

const String p1 = 'RedHatMedium';
const String p2 = 'RedHatRegular';


/// Error message displayed on InputFields
const String kInputErrorEmptyValue = 'Campo requerido.';
const String kInputErrorEmailMissmatch ='El correo indicado no existe.';
const String kInputErrorEmail ='El correo no ha sido dado de alta.';

const String kInputErrorToLong ='Maximo de caracteres alcanzado.';
const String kInputErrorPhone ='El telefono no existe.';
const String kInputErrorNotNum ='Introduzca un numero valido.';

const String kInputErrorPassword ='Contraseña Incorrecta. Vuelve a intentarlo.';
const String kInputErrorMin8 ='Debe tener un minimo de 8 caracteres.';
const String kInputErrorContainsDigit ='Debe contener al menos 1 digito.';


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