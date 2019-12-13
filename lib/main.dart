import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sorting_visualiser/sorting_canvas.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<int> arr;
  double width;
  bool isAlgorithmRunning;
  @override
  void initState() {
    super.initState();
    arr = _getRandomIntegerList();
    isAlgorithmRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sorting Visualiser'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10, 0.0),
              child: DropdownButton<String>(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                  size: 30,
                ),
                onChanged: (dynamic choice) async {
                  if (isAlgorithmRunning) {
                    return null;
                  }
                  List<int> sorted = List.from(arr);
                  sorted.sort();
                  if (listEquals(arr, sorted)) {
                    _showCenterToast("It is already sorted !");
                    return;
                  }

                  switch (choice) {
                    case 'Bubble Sort':
                      _setAlgorithmRunningState(true);
                      await _bubbleSortVisualiser();
                      _setAlgorithmRunningState(false);
                      _showCenterToast('Bubble Sort completed');
                      break;
                    case 'Selection Sort':
                      _setAlgorithmRunningState(true);
                      await _selectionSortVisualiser();
                      _setAlgorithmRunningState(false);
                      _showCenterToast('Selection Sort completed');
                      break;
                    case 'Insertion Sort':
                      _setAlgorithmRunningState(true);
                      await _insertionSortVisualiser();
                      _setAlgorithmRunningState(false);
                      _showCenterToast("Insertion Sort completed");

                      break;
                    case 'Quick Sort':
                      _setAlgorithmRunningState(true);
                      await _quickSortVisualiser(arr, 0, arr.length - 1);
                      _setAlgorithmRunningState(false);
                      _showCenterToast("Quick Sort completed");
                      break;
                  }
                },
                hint: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Algorithm",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 24),
                    ),
                  ),
                ),
                items: <String>[
                  'Bubble Sort',
                  'Selection Sort',
                  'Insertion Sort',
                  'Quick Sort'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                iconSize: 40,
              ),
            )
          ],
        ),
        //The following flatButton refreshes arr to have a new array of random integers.
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  setState(() {
                    arr = _getRandomIntegerList();
                  });
                },
                child: Icon(
                  Icons.refresh,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Made by Vineet Kalghatgi",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPaint(
              willChange: true,
              isComplex: true,
              size: Size(window.physicalSize.width, double.infinity),
              painter: SortingCanvas(arr),
            ),
          ),
        ),
      ),
    );
  }

  //function to sort the list using BUBBLE SORT and repaint the canvas at every iteration.
  _bubbleSortVisualiser() async {
    print('Bubble sort visualiser called');
    List<int> bubbleArr = List.from(arr);

    for (int i = 0; i < bubbleArr.length - 1; i++) {
      for (int j = 0; j < bubbleArr.length - 1 - i; j++) {
        int temp;
        if (bubbleArr[j] > bubbleArr[j + 1]) {
          temp = bubbleArr[j];
          bubbleArr[j] = bubbleArr[j + 1];
          bubbleArr[j + 1] = temp;

          //Every time arr changes setState() is called to visualise the changing array.
          await Future.delayed(const Duration(microseconds: 500), () {
            setState(() {
              arr = List.from(bubbleArr);
              print("Updated to : $arr");
            });
          });
        }
      }
    }
  }

  //function to sort the list using SELECTION SORT and repaint the canvas at every iteration.
  _selectionSortVisualiser() async {
    print('Selection sort visualiser called');
    List<int> selectArr = List.from(arr);
    int min_index, temp;

    for (int i = 0; i < selectArr.length - 1; i++) {
      min_index = i;
      for (int j = i + 1; j < selectArr.length; j++) {
        if (selectArr[j] < selectArr[min_index]) {
          min_index = j;
        }
      }

      temp = selectArr[i];
      selectArr[i] = selectArr[min_index];
      selectArr[min_index] = temp;

      await Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          arr = List.from(selectArr);
          print("Updated to : $arr");
        });
      });
    }
  }

  //function to sort the list using INSERTION SORT and repaint the canvas at every iteration.
  _insertionSortVisualiser() async {
    print('Insertion sort visualiser called');
    List<int> insertArr = List.from(arr);
    int key, j;

    for (int i = 1; i < insertArr.length; i++) {
      key = insertArr[i];
      j = i - 1;

      while (j >= 0 && insertArr[j] > key) {
        insertArr[j + 1] = insertArr[j];
        j = j - 1;
      }
      insertArr[j + 1] = key;
      await Future.delayed(const Duration(milliseconds: 80), () {
        setState(() {
          arr = List.from(insertArr);
          print("Updated to : $arr");
        });
      });
    }
  }

  //function to sort the list using QUICK SORT and repaint the canvas at every iteration.
  _quickSortVisualiser(List<int> quickArr, int low, int high) async {
    print('Quick sort visualiser called');
    int pivot;
    List<int> quickArr = List.from(arr);
    if (low < high) {
      /* pi is partitioning index, arr[pi] is now
           at right place */
      pivot = await _partition(arr, low, high);

      await _quickSortVisualiser(quickArr, low, pivot - 1); // Before pi
      await _quickSortVisualiser(quickArr, pivot + 1, high); // After pi
    }
  }

  Future<int> _partition(List<int> quickArr, int low, int high) async {
    int pivot = quickArr[high];
    int i = (low - 1);
    int temp;
    for (int j = low; j <= high - 1; j++) {
      if (quickArr[j] < pivot) {
        i++;
        temp = quickArr[i];
        quickArr[i] = quickArr[j];
        quickArr[j] = temp;
        await _updateArrayWithDelay(quickArr);
      }
    }
    temp = quickArr[i + 1];
    quickArr[i + 1] = quickArr[high];
    quickArr[high] = temp;
    await _updateArrayWithDelay(quickArr);
    return (i + 1);
  }

  //async update method for recursive sorting algorithms
  _updateArrayWithDelay(List<int> updatedArr) async {
    await Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        arr = List.from(updatedArr);
        print("Updated to : $arr");
      });
    });
  }

  void _setAlgorithmRunningState(bool state) {
    setState(() {
      isAlgorithmRunning = state;
    });
  }

  //Helper function to get a list of 15 random integers
  List<int> _getRandomIntegerList() {
    List<int> arr = [];
    double width = window.physicalSize.height - 800;
    Random rng = new Random();
    for (int i = 0; i < window.physicalSize.width / 2 - 150; i++) {
      arr.add(rng.nextInt(400) + 1);
    }
    return arr;
  }
}

_showCenterToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blueAccent,
    textColor: Colors.white,
  );
}
