import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SortingCanvas extends CustomPainter {
  List<int> arr;
  List<int> greenIndexes;

  SortingCanvas(this.arr, [this.greenIndexes]);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    var greenLine = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..isAntiAlias = true;
    //IMP the first offset is the bottom point and the second is the top point of the vertical line.
    //It is offset from the top left corner of the canvas
    for (int i = 1; i <= arr.length; i++) {
      if (greenIndexes.contains(i - 1)) {
        canvas.drawLine(Offset(i * 1.0, size.height - 30),
            Offset(i * 1.0, size.height - (arr[i - 1] + 100)), greenLine);
      } else
        canvas.drawLine(Offset(i * 1.0, size.height - 30),
            Offset(i * 1.0, size.height - (arr[i - 1] + 100)), linePaint);
    }
  }

  @override
  bool shouldRepaint(SortingCanvas oldDelegate) {
    return !listEquals(this.arr, oldDelegate.arr);
  }
}
