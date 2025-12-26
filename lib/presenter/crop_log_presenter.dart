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

      if (response.status >= 200 && response.status < 300) {
        // Request was successful (2xx range)
        requestState = RequestState.success;
      } else if (response.status >= 400 && response.status < 500) {
        // Client error occurred (4xx range)
        print('Client error: ${response.status}');
        throw Exception('Failed to load data due to a client error');
      } else {
        // Other errors (e.g., server error 5xx, redirects 3xx)
        print('Other error: ${response.status}');
        throw Exception('Failed to load data with status code: ${response.status}');
      }
    } catch (e) {
      message = e.toString();
      requestState = RequestState.error;
    }
  }
}
