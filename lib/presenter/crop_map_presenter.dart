import 'package:asisten_buku_kebun/data/model/crop_model.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CropMapPresenter {
  RequestState requestState = RequestState.initial;
  List<CropModel> allCrops = [];
  String message = '';

  void reset() {
    requestState = RequestState.initial;
    allCrops = [];
    message = '';
  }

  Future<void> fetchAllCrop() async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      var result = Supabase.instance.client.from('crops').select('''
      crop_id,
      user_id,
      crop_name,
      type,
      crop_status,
      location_lat,
      location_lon,
      created_at,
      users (
        name
      )
      ''');
      var cropsData = await result.then((value) => value as List<dynamic>);
      print(cropsData);
      allCrops = cropsData.map((e) => CropModel.fromJson(e)).toList();
      print("All Crops: " + allCrops.toString());
      requestState = RequestState.success;
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
    }
  }
}
