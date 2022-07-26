

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';

import '../constants/string.dart';

bool isNull(item){
  return item==null;
}
bool isNotNull(item){
  return item!=null;
}
bool isEmpty(item){
  return item.isEmpty;
}
bool isNotEmpty(item){
  return item.isNotEmpty;
}

bool isNullOrEmpty(item){
  return isNull(item)||isEmpty(item);
}

bool isNotNullOrEmpty(item){
  return isNotNull(item)&&isNotEmpty(item);
}

/// Validations
String? validateNumber(String? value){
  double? number;
  if(isNullOrEmpty(value)){
    return kInputErrorEmptyValue;
  }
  value = value!.replaceAll(',', '.');
  number = toDouble(value);
  if(isNull(number)){
    return kInputErrorNotNum;
  }
  if(number!.isNaN||number.isNegative||number>500){
    return kInputErrorNotNum;
  }
  return null;
}

String? normalize(String? value){
  if(value==null) return null;
  String res = value.toLowerCase();
  res = res.replaceFirst(res.characters.first, res.characters.first.toUpperCase());
  return res;
}

String? toCamellCase(String? value){
  value = value!.toLowerCase();
  List<String> _list = value.split(" ");
  String res = "";
  for(String x in _list){
    res+= x.replaceFirst(x.characters.first, x.characters.first.toUpperCase());
    res+=" ";
  }
  return res.trim();
}

double? toDouble(String? value){
  value = value!.replaceAll(',', '.');
  try{  return  double.parse(value); }
  catch(E){ return null;  }
}

Map<String, dynamic>? toMap(DocumentSnapshot doc){
  try{
    return doc.data() as Map<String, dynamic>;
  }catch(E){
    logError("DocumentSnapshot fails in cast to Map<String, dynamic):\n $E");
  }
}
