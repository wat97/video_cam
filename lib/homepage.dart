import 'package:flutter/material.dart';
import 'package:video_cam/camera_custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size? size;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      setState(() {
        size = MediaQuery.of(context).size;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) return Container();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: size != null ? size!.height * 0.1 : 90,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "Camera App",
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CameraCustom(),
              ));
              print("clickData");
            },
            child: Container(
              width: size!.width * 0.9,
              padding: EdgeInsets.symmetric(
                vertical: size!.height * 0.01,
              ),
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  border: Border.all(
                    color: Colors.black,
                  )),
              child: const Text(
                "Click Camera",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
