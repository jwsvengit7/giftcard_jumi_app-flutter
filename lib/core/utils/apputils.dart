import 'package:flutter/material.dart';

class AppUtils {
  static Divider divider(double thickness,Color color,double height) {
    return Divider(
      color:  color,
      height: height,
      thickness: thickness,
    );
  }
}
