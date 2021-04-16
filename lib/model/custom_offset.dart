import 'package:flutter/painting.dart';

class CustomOffset extends Offset {
  double dx, dy;
  CustomOffset({this.dx, this.dy}) : super(dx, dy);

  Map<String, dynamic> toJson() => {'dx': dx, 'dy': dy};

  factory CustomOffset.fromJson(Map<String, dynamic> json) {
    return CustomOffset(dx: json['dx'], dy: json['dy']);
  }
}
