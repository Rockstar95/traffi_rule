import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traffi_rule/utils/parsing_helper.dart';

class UserModel {
  String id = "", name = "", image = "", mobile = "", email = "";
  Timestamp? createdTime;

  UserModel();

  UserModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    image = ParsingHelper.parseStringMethod(map['image']);
    mobile = ParsingHelper.parseStringMethod(map['mobile']);
    email = ParsingHelper.parseStringMethod(map['email']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "name" : name,
      "image" : image,
      "mobile" : mobile,
      "email" : email,
      "createdTime" : createdTime,
    };
  }

  @override
  String toString() {
    return "id:$id, name:$name, image:$image, mobile:$mobile, email:$email, createdTime:$createdTime";
  }
}