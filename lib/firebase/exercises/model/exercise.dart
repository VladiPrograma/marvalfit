
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/utils/marval_arq.dart';

class Exercise {
  String id;
  String name;
  String description;
  String link;
  String imageUrl;
  List<String> tags;


  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.link,
    required this.tags,
  });

  Exercise.create(this.name, this.link, this.description, this.imageUrl, this.tags)
  :     id = Timestamp.now().microsecondsSinceEpoch.toString();


  Exercise.empty()
  :     id = '',
        name = '',
        description = '',
        imageUrl = '',
        link = '',
        tags = [];

  Exercise.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        description = map["description"],
        imageUrl = map["image_url"],
        link = map["link"],
        tags = List<String>.from(map["tags"]).sorted();

  Map<String, dynamic> toMap(){
    return {
      'id': id, // Vlad
      'name': name.normalize(), // Vlad
      'image_url': imageUrl, // Dumitru
      'link': link, // Dumitru
      'description': description.normalize(), // Dumitru
      'tags': tags,
      'keywords' : getKeywords(name.toLowerCase())
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      description == other.description &&
      link == other.link &&
      imageUrl == other.imageUrl &&
      eq(tags, other.tags);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      link.hashCode ^
      imageUrl.hashCode ^
      tags.hashCode;

  @override
  String toString() {
    return 'Exercise {id: $id, name: $name, description: $description, tags: $tags image : $imageUrl link: $link}';
  }

}