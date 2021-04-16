import 'package:flutter/material.dart';

class SelectColorWidget extends StatelessWidget {
  final Function onColorChanged;
  final double width = 40.0;

  const SelectColorWidget({Key key, this.onColorChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Row(
        children: [
          ColorItemWidget(
              color: Colors.redAccent,
              onColorChanged: onColorChanged,
              width: width),
          ColorItemWidget(
              color: Colors.yellowAccent,
              onColorChanged: onColorChanged,
              width: width),
          ColorItemWidget(
              color: Colors.pink, onColorChanged: onColorChanged, width: width),
        ],
      ),
    );
  }
}

class ColorItemWidget extends StatelessWidget {
  final Color color;

  const ColorItemWidget({
    Key key,
    @required this.onColorChanged,
    @required this.width,
    @required this.color,
  }) : super(key: key);

  final Function onColorChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          onColorChanged(color);
        },
        child: Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(width / 2)),
        ),
      ),
    );
  }
}
