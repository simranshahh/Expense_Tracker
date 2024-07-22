// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

class ProfilepictureModel {
  String photoId;
  Uint8List PImage;

  ProfilepictureModel({required this.PImage, required this.photoId});

  factory ProfilepictureModel.fromMap(Map<String, dynamic> json) =>
      ProfilepictureModel(
        photoId: json["photoId"],
        PImage: json["pImage"],
      );

  Map<String, dynamic> toMap() => {
        "photoId": photoId,
        "pImage": PImage,
      };
}
