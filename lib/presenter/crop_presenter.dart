import 'dart:async';

import 'package:asisten_buku_kebun/data/model/crop_model.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CropPresenter {
  RequestState requestState = RequestState.initial;

  List<CropModel> myCrops = [];
  String message = '';
  CropModel? selectedCrop;

  void reset() {
    requestState = RequestState.initial;
    myCrops = [];
    message = '';
    selectedCrop = null;
  }

  Future<void> fetchMyCrops(String userId) async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      var result = Supabase.instance.client
          .from('crops')
          .select()
          .eq('user_id', userId);
      var cropsData = await result.then((value) => value as List<dynamic>);
      myCrops = cropsData.map((e) => CropModel.fromJson(e)).toList();
      requestState = RequestState.success;
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
    }
  }

  Future<void> addCrop(CropModel crop) async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      // var result =
      await Supabase.instance.client.from('crops').insert(crop.toJson()).select().single();
      // CropModel? resultData = CropModel.fromJson(result);
      requestState = RequestState.success;
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
    }
  }

  Future<void> editCrop(CropModel crop) async {
    requestState = RequestState.initial;
    try {
      requestState = RequestState.loading;
      await Supabase.instance.client
          .from('crops')
          .update(crop.toJson())
          .eq('crop_id', crop.cropId!).select().single();


      requestState = RequestState.success;
    } catch (e) {
      requestState = RequestState.error;
      message = e.toString();
    }
  }

}
