import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_position/components/select_color_widget.dart';
import 'package:sun_position/helpers/shared_preferences_helper.dart';
import 'package:sun_position/model/custom_offset.dart';

import 'line_painter.dart';
import 'model/path_step.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Path path;
  Color _color;

  String currentChar = "A";

  double _x = 0, _y = 0;

  bool isDrawing = true;

  final double pointerRadius = 40.0;
  List<PathStep> pathSteps = [];
  int currentKeyPointIndex = 0;

  bool isDrawingGuide = true;

  int guideTapDownCounts = 0;

  CustomOffset previousPosition;

  @override
  void initState() {
    initPath();
    loadSavedPathSteps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Listener(
        onPointerMove: onPointerMove,
        onPointerCancel: (PointerCancelEvent event) => isDrawing = false,
        onPointerUp: (PointerUpEvent event) => isDrawing = false,
        onPointerDown: onTapDown,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              currentChar,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 270,
                  color: Colors.grey),
            ),
            CustomPaint(
              painter: LinePainter(path: path, color: _color),
              child: Container(),
            ),
            Positioned(
              left: _x,
              top: _y,
              child: Visibility(
                visible: !isDrawingGuide,
                child: Container(
                  width: pointerRadius,
                  height: pointerRadius,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withAlpha(100)),
                ),
              ),
            ),
            SelectColorWidget(onColorChanged: (color) {
              setState(() {
                _color = color;
              });
            })
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              initPath();
              setState(() {});
            },
          ),
          Row(
            children: [
              Text("Draw Guide :"),
              Switch(
                value: isDrawingGuide,
                onChanged: (value) {
                  setState(() {
                    isDrawingGuide = value;
                    if (isDrawingGuide == false) {
                      SharedPreferencesHelper.instance
                          .save(currentChar, pathSteps);
                    } else {
                      loadSavedPathSteps();
                      setState(() {});
                    }
                    // initPath();
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void onPointerMove(PointerEvent details) {
    if (isDrawingGuide) return;
    RenderBox getBox = context.findRenderObject();
    final Offset localOffset = getBox.globalToLocal(details.position);

    if (isDrawing) {
      path.lineTo(localOffset.dx, localOffset.dy);
    } else {
      isDrawing = true;
      path.moveTo(localOffset.dx, localOffset.dy);
    }

    _x = localOffset.dx - pointerRadius / 2;
    _y = localOffset.dy - pointerRadius / 2;

    print("${localOffset.dx}, ${localOffset.dy}");

    setState(() {});
  }

  void onTapDown(PointerDownEvent details) {
    if (!isDrawingGuide) return;

    RenderBox getBox = context.findRenderObject();
    final Offset localOffset = getBox.globalToLocal(details.position);

    guideTapDownCounts++;

    if (guideTapDownCounts % 2 == 0) {
      // last
      pathSteps.add(PathStep(
          start: previousPosition,
          end: CustomOffset(dx: localOffset.dx, dy: localOffset.dy)));
      previousPosition = null;
      path.lineTo(localOffset.dx, localOffset.dy);
    } else {
      // first
      path.moveTo(localOffset.dx, localOffset.dy);
      _x = localOffset.dx - pointerRadius / 2;
      _y = localOffset.dy - pointerRadius / 2;
      previousPosition = CustomOffset(dx: localOffset.dx, dy: localOffset.dy);
    }

    print("${localOffset.dx}, ${localOffset.dy}");
    print(pathSteps?.length.toString());

    setState(() {});
  }

  void initPath() {
    path = Path();
    pathSteps = [];
  }

  void loadSavedPathSteps() async {
    pathSteps =
        await SharedPreferencesHelper.instance.loadPathSteps(currentChar);

    for (int i = 0; i < pathSteps.length; i++) {
      final pathStep = pathSteps.elementAt(i);
      path.moveTo(pathStep.start.dx, pathStep.start.dy);
      path.lineTo(pathStep.end.dx, pathStep.end.dy);
    }
    setState(() {});
  }
}
