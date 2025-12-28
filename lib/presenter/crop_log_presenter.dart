import 'dart:typed_data';
import 'package:asisten_buku_kebun/data/model/crop_log_model.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CropLogPresenter {
  RequestState requestState = RequestState.initial;
  List<CropLogModel> cropLogs = [];

  String message = '';

  void reset() {
    requestState = RequestState.initial;
    cropLogs = [];
    message = '';
  }

  Future<List<CropLogModel>> fetchLatestCropLogs(
    String userId, {
    int limit = 5,
  }) async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      final result = await Supabase.instance.client
          .from('crop_logs')
          .select('''
          crop_log_id,
          created_at,
          crop_id,
          notes,
          log_tag,
          image_url,
          crops!inner (
            crop_id,
            user_id
          )
        ''')
          .eq('crops.user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      final logsData = result as List<dynamic>;
      requestState = RequestState.loaded;
      return logsData.map((e) => CropLogModel.fromJson(e)).toList();
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
      throw Exception('Failed to fetch latest crop logs: $e');
    }
  }

  Future<void> fetchCropLogs(String cropId) async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      var result = await Supabase.instance.client
          .from('crop_logs')
          .select()
          .eq('crop_id', cropId);
      var logsData = result as List<dynamic>;
      cropLogs = logsData.map((e) => CropLogModel.fromJson(e)).toList();
      requestState = RequestState.success;
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
    }
  }

  Future<void> addCropLog({
    required String cropId,
    required String notes,
    required String tag,
    required XFile photo,
  }) async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      final compressedBytes = await compressImageBytes(photo.path);
      final response = await Supabase.instance.client.functions.invoke(
        'log-crop-update',
        body: {
          'crop_id': cropId,
          'notes': notes,
          'tag': tag,
          'file': compressedBytes,
        },
      );

      if (response.status >= 200 && response.status < 300) {
        requestState = RequestState.success;
      } else if (response.status >= 400 && response.status < 500) {
        print('Client error: ${response.status}');
        throw Exception('Failed to load data due to a client error');
      } else {
        print('Other error: ${response.status}');
        throw Exception(
          'Failed to load data with status code: ${response.status}',
        );
      }
    } catch (e) {
      message = e.toString();
      requestState = RequestState.error;
    }
  }

  Future<Uint8List> compressImageBytes(String filePath) async {
    final result = await FlutterImageCompress.compressWithFile(
      filePath,
      minWidth: 1024,
      quality: 70,
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      throw Exception('Failed to compress image');
    }

    return result;
  }
}
