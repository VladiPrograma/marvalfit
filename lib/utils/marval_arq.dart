

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