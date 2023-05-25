import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:video_cam/file_camera.dart';

class CameraCustom extends StatefulWidget {
  const CameraCustom({super.key});

  @override
  State<CameraCustom> createState() => _CameraCustomState();
}

class _CameraCustomState extends State<CameraCustom> {
  Size? size;
  CameraController? controller;
  List cameras = [];
  int selectedCamera = 0;
  int secondTime = 0;
  Stopwatch? stopwatch;
  XFile? fileVideo;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      setState(() {
        size = MediaQuery.of(context).size;
        stopwatch = Stopwatch();
        initCamera();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) return Container();
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: size != null ? size!.height * 0.1 : 90,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "Camera",
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            contentPage(),
          ],
        ),
      ),
    );
  }

  Widget contentPage() {
    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: cameraPreviewWidget(),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              children: [
                const Text(
                  "Video Preview",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                controller!.value.isRecordingVideo
                    ? CountdownTimer(
                        endTime: DateTime.now()
                            .add(const Duration(seconds: 15))
                            .millisecondsSinceEpoch,
                        widgetBuilder: (_, time) {
                          print("time $time, ");
                          if (time == null) {
                            // var videoOutput = await controller!.stopVideoRecording();
                            stopwatch!.reset();

                            return Container();
                          }
                          ;
                          return SizedBox(
                            child: Text(
                              "Ada ${time.sec}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (controller!.value.isRecordingVideo) {
                      fileVideo = await controller!.stopVideoRecording();
                      stopwatch!.reset();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const CameraCustom(),
                      // ));

                      print("videoOutput ${await fileVideo!.length()}");
                    } else {
                      controller!.prepareForVideoRecording();
                      stopwatch!.start();
                      controller!.addListener(() {
                        print("mountedVideoDataListener");
                        if (mounted) {
                          setState(() {
                            print("mountedVideoListener");
                          });
                        }
                      });
                      await controller!.startVideoRecording().then((value) {
                        print("mountedVideoData");
                        if (mounted) {
                          setState(() {
                            print("mountedVideo");
                          });
                        }
                      });
                    }
                  },
                  child: Icon(
                    controller!.value.isRecordingVideo
                        ? Icons.stop
                        : Icons.camera,
                    size: size!.width * 0.2,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FileCamera(
                        argsFile: fileVideo!,
                      ),
                    ));
                  },
                  child: Icon(
                    Icons.video_camera_back,
                    size: size!.width * 0.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cameraPreviewWidget() {
    print("cameraPreview ${controller?.value.isInitialized}");
    if (controller != null && controller!.value.isInitialized) {
      return CameraPreview(controller!);
    }
    return const Center(
      child: Text(
        'Loading',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  initCamera() async {
    await availableCameras().then((value) {
      print("available Camera ${value}");
      cameras = value;
      if (cameras.isNotEmpty) {
        selectedCamera = 0;
        initControllerCamera(cameras[selectedCamera]).then((value) {
          print("initController $value");
          if (!mounted) {
            print("not mounted");
            return;
          } else {
            setState(() {});
          }
          setState(() {});
        }).catchError((Object e) {
          if (e is CameraException) {
            print("Excepption Camera ${e.description}");
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
        ;
      } else {
        print("No Camera available");
      }
    });
  }

  Future initControllerCamera(CameraDescription cameraDescription) async {
    print("cameraControllerData ");
    try {
      if (controller != null) {
        print("cameraControllerData Dispose");
        await controller!.dispose();
      } else {
        controller = CameraController(
          cameraDescription,
          ResolutionPreset.max,
          enableAudio: true,
        );
        controller!.addListener(() {
          setState(() {
            if (controller!.value.hasError) {
              print(
                  "Camera Error Controller ${controller!.value.errorDescription}");
            }
          });
        });
        try {
          setState(() async {
            await controller!.initialize();
          });
        } catch (e) {
          print('Camera Exception ${e}');
        }
      }
    } catch (e) {
      print("Camera-Exception ");
    }
    print("dataS");
    setState(() {});
  }
}
