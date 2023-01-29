
import 'package:collection/collection.dart';

class Tags {
  List<String> values;


  Tags({ required this.values  });
  Tags.empty(): values = [];

  Tags.fromMap(Map<String, dynamic> map)
      : values = List<String>.from(map["values"]).sorted();

  Map<String, dynamic> toMap(){
    return { 'values': values };
  }

  void order() => values.sort();

  @override
  String toString() {
    return 'Tags{ $values }';
  }
}