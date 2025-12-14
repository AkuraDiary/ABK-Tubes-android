import 'package:asisten_buku_kebun/presenter/auth_presenter.dart';
import 'package:camera/camera.dart';

class DI {
  static late List<CameraDescription> cameras;
  static late AuthPresenter authPresenter;
  static void init() {
    // Initialization code here
    authPresenter = AuthPresenter();
  }
}