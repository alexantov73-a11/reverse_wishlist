import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _imagePicker = ImagePicker();
  late List<CameraDescription> _cameras;

  Future<void> init() async {
    _cameras = await availableCameras();
  }

  List<CameraDescription> get cameras => _cameras;

  Future<String?> pickImageFromCamera() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      return photo?.path;
    } catch (e) {
      return null;
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      return photo?.path;
    } catch (e) {
      return null;
    }
  }

  Future<bool> requestCameraPermission() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }
}
