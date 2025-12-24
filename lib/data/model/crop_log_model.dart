class CropLogModel {
  String? cropLogId;
  String? createdAt;
  String? cropId;
  String? notes;
  String? logTag;
  String? imageUrl;

  CropLogModel(
      {this.cropLogId,
        this.createdAt,
        this.cropId,
        this.notes,
        this.logTag,
        this.imageUrl});

  CropLogModel.fromJson(Map<String, dynamic> json) {
    cropLogId = json['crop_log_id'];
    createdAt = json['created_at'];
    cropId = json['crop_id'];
    notes = json['notes'];
    logTag = json['log_tag'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['crop_log_id'] = cropLogId;
    data['created_at'] = createdAt;
    data['crop_id'] = cropId;
    data['notes'] = notes;
    data['log_tag'] = logTag;
    data['image_url'] = imageUrl;
    return data;
  }
}

