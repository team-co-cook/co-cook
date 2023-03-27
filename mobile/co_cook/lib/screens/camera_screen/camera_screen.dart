import 'dart:io';

import 'package:camera/camera.dart';
import 'package:co_cook/screens/camera_screen/widgets/camera_result.dart';
import 'package:co_cook/styles/colors.dart';
import 'package:co_cook/styles/text_styles.dart';
import 'package:co_cook/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  bool isCameraInitialized = false;
  bool isProcess = false;
  late String tmpImgPath;

  void _getTmpImgPath() async {
    Directory tmpPath = await getTemporaryDirectory();
    tmpImgPath = '${tmpPath.path}/searchImageFile/${DateTime.now()}.png';
  }

  Future<void> _takePhoto() async {
    _cameraController.pausePreview();
    setState(() {
      isProcess = true;
    });
    XFile imgFile = await _cameraController.takePicture();
  }

  Future _checkAvailableCameras() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    await _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController.setFocusMode(FocusMode.auto);
      setState(() {
        isCameraInitialized = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            Navigator.pop(context);
            break;
          default:
            // Handle other errors here.
            Navigator.pop(context);
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getTmpImgPath();
    _checkAvailableCameras();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      isCameraInitialized
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_cameraController))
          : Container(),
      AnimatedPositioned(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Color.fromARGB(67, 0, 0, 0),
                      width: 1000,
                      strokeAlign: BorderSide.strokeAlignOutside),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Text("찾고싶은 음식을 보여주세요",
                    style: CustomTextStyles().subtitle1.copyWith(
                          color: CustomColors.monotoneLight,
                        )),
              )
            ],
          ),
        ),
      ),
      Positioned(
          right: 40,
          bottom: 60,
          child: SafeArea(
            child: ZoomTapAnimation(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(53, 0, 0, 0),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: CustomColors.redLight,
                  ),
                )),
          )),
      Positioned(
          left: 0,
          right: 0,
          bottom: 60,
          child: isProcess
              ? Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                      color: CustomColors.monotoneLight))
              : ZoomTapAnimation(
                  onTap: () => _takePhoto(),
                  child: Icon(
                    Icons.circle,
                    size: 60,
                    color: CustomColors.redLight,
                  ))),
      Positioned(
          left: 40,
          bottom: 60,
          child: ZoomTapAnimation(
              onTap: () async {
                if (isProcess) {
                } else {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  print(image!.path);
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(53, 0, 0, 0),
                ),
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 24,
                  color: isProcess
                      ? CustomColors.monotoneGray
                      : CustomColors.redLight,
                ),
              ))),
    ]);
  }
}
