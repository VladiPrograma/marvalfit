import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/extensions.dart';
import '../config/log_msg.dart';
import '../constants/string.dart';

bool isNull(item) => item==null;

bool isNotNull(item) => item!=null;

bool isEmpty(item) => item.isEmpty;

bool isNotEmpty(item) => item.isNotEmpty;

bool isNullOrEmpty(item) => isNull(item)||isEmpty(item);

bool isNotNullOrEmpty(item) => isNotNull(item)&&isNotEmpty(item);

/// Validations
String? validateNumber(String? value){
  double? number;
  if(isNullOrEmpty(value)){ return kEmptyValue; }
  number = value!.toDouble();
  if(isNull(number)){ return kNotNum; }

  if(number!.isNaN||number.isNegative||number>500){
    return kNotNum;
  }
  return null;
}

Map<String, dynamic>? toMap(DocumentSnapshot doc){
  try{  return doc.data() as Map<String, dynamic>; }
  catch(E){  logError("DocumentSnapshot fails in cast to Map<String, dynamic):\n $E"); }
  return null;
}
