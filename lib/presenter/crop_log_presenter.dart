import 'package:asisten_buku_kebun/data/model/crop_log_model.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:camera/camera.dart';
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


      final bytes = await photo.readAsBytes();
      final response = await Supabase.instance.client.functions.invoke(
        'log-crop-update',
        body: {
          'crop_id': cropId,
          'notes': notes,
          'tag': tag,
          'file': bytes,
        },
      );
      requestState = RequestState.success;
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
    }
  }
}
