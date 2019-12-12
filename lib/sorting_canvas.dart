import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SortingCanvas extends CustomPainter {
  List<int> arr;

  SortingCanvas(this.arr);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..isAntiAlias = true;
    //IMP the first offset is the bottom point and the second is the top point of the vertical line.
    //It is offset from the top left corner of the canvas
    for (int i = 1; i <= arr.length; i++) {
      canvas.drawLine(Offset( i*1.0, size.height - 30),
          Offset( i*1.0, size.height - (arr[i - 1] +100)), linePaint);
    }
  }

  @override
  bool shouldRepaint(SortingCanvas oldDelegate) {
    return !listEquals(this.arr, oldDelegate.arr);
  }
}
