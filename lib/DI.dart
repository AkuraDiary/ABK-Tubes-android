import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_log_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_map_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_presenter.dart';
import 'package:camera/camera.dart';

class DI {
  static String bcryptSalt = '\$2b\$10\$CwTycUXWue0Thq9StjUM0u';
  static late List<CameraDescription> cameras;
  static late AuthPresenter authPresenter;
  static late CropLogPresenter cropLogPresenter;
  static late CropPresenter cropPresenter;
  static late CropMapPresenter cropMapPresenter;
  static void init() {
    // Initialization code here
    authPresenter = AuthPresenter();
    cropLogPresenter = CropLogPresenter();
    cropPresenter = CropPresenter();
    cropMapPresenter = CropMapPresenter();

  }
}