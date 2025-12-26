import 'package:asisten_buku_kebun/data/model/crop_model.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CropMapPresenter {
  RequestState requestState = RequestState.initial;
  List<CropModel> myCrops = [];
  String message = '';

  void reset() {
    requestState = RequestState.initial;
    myCrops = [];
    message = '';
  }

  Future<void> fetchAllCrop() async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      var result = Supabase.instance.client.from('crops').select();
      var cropsData = await result.then((value) => value as List<dynamic>);
      myCrops = cropsData.map((e) => CropModel.fromJson(e)).toList();
      requestState = RequestState.success;
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
    }
  }
}
