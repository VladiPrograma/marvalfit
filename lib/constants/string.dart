
const String h1 = 'RedHatBlack';
const String h2 = 'RedHatBold';

const String p1 = 'RedHatMedium';
const String p2 = 'RedHatRegular';


/// Error message displayed on InputFields
const String inputErrorEmptyValue = 'Se requiere completar el campo.';
const String inputErrorEmailMissmatch ='El correo indicado no existe.';
const String inputErrorEmail ='El correo no ha sido dado de alta.';

const String inputErrorPassword ='Contraseña Incorrecta. Vuelve a intentarlo.';
const String inputErrorMin8 ='Debe tener un minimo de 8 caracteres.';
const String inputErrorContainsDigit ='Debe contener al menos 1 digito.';

class ErrorText{
  late String text;
  ErrorText( this.text);
  ErrorText.emptyValue():text = 'Se requiere completar el campo.';

  @override
  String toString(){
    return text;
  }

}