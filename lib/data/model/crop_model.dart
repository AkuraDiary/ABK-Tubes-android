import 'package:asisten_buku_kebun/data/model/user_model.dart';

class CropModel {
  String? cropId;
  String? userId;
  String? cropName;
  String? type;
  String? cropStatus;
  double? locationLat;
  double? locationLon;
  String? createdAt;
  UserModel? user;

  CropModel({
    this.cropId,
    this.userId,
    this.cropName,
    this.type,
    this.cropStatus,
    this.locationLat,
    this.locationLon,
    this.createdAt,
    this.user,
  });

  CropModel.fromJson(Map<String, dynamic> json) {
    cropId = json['crop_id'];
    userId = json['user_id'];
    cropName = json['crop_name'];
    type = json['type'];
    cropStatus = json['crop_status'];
    locationLat = json['location_lat'];
    locationLon = json['location_lon'];
    createdAt = json['created_at'];
    user = json['users'] != null ? UserModel.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['crop_id'] = cropId;
    data['user_id'] = userId;
    data['crop_name'] = cropName;
    data['type'] = type;
    data['crop_status'] = cropStatus;
    data['location_lat'] = locationLat;
    data['location_lon'] = locationLon;
    data['created_at'] = createdAt;
    if (user != null) {
      data['users'] = user!.toJson();
    }
    return data;
  }
}
