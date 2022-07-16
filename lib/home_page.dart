import 'dart:ui';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  double offset = 0;
  final tabCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        offset = _pageController.offset;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(controller: _pageController, children: [
            Image.asset(
              'assets/3.jpg',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images.jpg',
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/download.jpg',
              fit: BoxFit.cover,
            )
          ]),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.width >
                        MediaQuery.of(context).size.height
                    ? 100
                    : 150.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 12, right: 12, top: 10, bottom: 20),
                          child: Text('Dynamic Tabs',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Stack(
                            children: [
                              tabs(
                                  isNegative: false,
                                  pageController: _pageController),
                              LayoutBuilder(builder: (context, constraints) {
                                var ratio = MediaQuery.of(context).size.width *
                                    tabCount /
                                    constraints.maxWidth;

                                return ClipPath(
                                    clipper: CustomClipperImage(
                                        offset: offset / ratio,
                                        width: constraints.maxWidth / 3),
                                    child: Container(
                                        color: Colors.white,
                                        child: tabs(
                                            isNegative: true,
                                            pageController: _pageController)));
                              })
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget tabs(
    {required bool isNegative, required PageController pageController}) {
  var color = isNegative ? Colors.black : Colors.white;
  const double sliderHeight = 30;

  Widget item({required String title, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        },
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  return SizedBox(
    height: sliderHeight,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      item(title: 'Iceland', index: 0),
      item(title: 'France', index: 1),
      item(title: 'Brazil', index: 2)
    ]),
  );
}

class CustomClipperImage extends CustomClipper<Path> {
  CustomClipperImage({required this.offset, required this.width});
  double offset;
  double width;

  @override
  Path getClip(Size size) {
    final double height = size.height;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(offset, 0, width, height), const Radius.circular(20)))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
