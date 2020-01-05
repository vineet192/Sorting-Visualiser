import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sorting_visualiser/sorting_canvas.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Locks the orientation of the device to portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(HomePage());
  });
}

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
              child: IgnorePointer(
                ignoring: isAlgorithmRunning,
                child: DropdownButton<String>(
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  onChanged: (dynamic choice) async {
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
                      case 'Merge Sort':
                        _setAlgorithmRunningState(true);
                        await _mergeSortVisualiser(arr, 0, arr.length - 1);
                        _setAlgorithmRunningState(false);
                        _showCenterToast("Merge Sort completed");
                        break;
                      case 'Heap Sort':
                        _setAlgorithmRunningState(true);
                        await _heapSortVisualiser(arr);
                        _setAlgorithmRunningState(false);
                        _showCenterToast("Heap Sort completed");
                        break;
                      case 'Gnome Sort':
                        _setAlgorithmRunningState(true);
                        await _gnomeSortVisualiser();
                        _setAlgorithmRunningState(false);
                        _showCenterToast("Gnome Sort completed");
                        break;
                    }
                  },
                  hint: Center(
                    child: Text(
                      "Algorithm",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                  items: <String>[
                    'Bubble Sort',
                    'Selection Sort',
                    'Insertion Sort',
                    'Quick Sort',
                    'Merge Sort',
                    'Heap Sort',
                    'Gnome Sort'
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
      await Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          arr = List.from(insertArr);
        });
      });
    }
  }

  //function to sort the list using QUICK SORT and repaint the canvas at every iteration.
  _quickSortVisualiser(List<int> quickArr, int low, int high) async {
    print('Quick sort visualiser called');
    int pivot;
    if (low < high) {
      /* pi is partitioning index, arr[pi] is now
           at right place */
      pivot = await _partition(arr, low, high);

      await _quickSortVisualiser(quickArr, low, pivot - 1); // Before pi
      await _quickSortVisualiser(quickArr, pivot + 1, high); // After pi
    }
  }

  //helper function to partition array for quicksort
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

  //function to sort the list using MERGE SORT and repaint the canvas at every iteration.
  _mergeSortVisualiser(List<int> mergeArr, int low, int high) async {
    print('Merge Sort called');
    print('Array size is : "${mergeArr.length}"');
    if (low < high) {
      // Same as (l+r)/2, but avoids overflow for
      // large l and h
      int mid = (low + (high - low) / 2).toInt();
      // Sort first and second halves
      await _mergeSortVisualiser(mergeArr, low, mid);
      await _mergeSortVisualiser(mergeArr, mid + 1, high);
      _updateArrayWithDelay(mergeArr);
      await merge(mergeArr, low, mid, high);
    }
  }

  //helper function to merge the array for merge sort
  merge(List<int> mergeArr, int low, int mid, int high) async {
    int i, j, k;
    int n1 = mid - low + 1;
    int n2 = high - mid;

    /* create temp arrays */
    List<int> L = [], R = [];

    /* Copy data to temp arrays L[] and R[] */
    for (i = 0; i < n1; i++)
      L.add(mergeArr[low + i]); //L[i] = mergeArr[low + i];
    for (j = 0; j < n2; j++)
      R.add(mergeArr[mid + 1 + j]); //R[j] = mergeArr[mid + 1 + j];

    i = 0;
    j = 0;
    k = low;
    while (i < n1 && j < n2) {
      if (L[i] <= R[j]) {
        mergeArr[k] = L[i];
        i++;
      } else {
        mergeArr[k] = R[j];
        j++;
      }
      await _updateArrayWithDelay(mergeArr);
      k++;
    }

    while (i < n1) {
      mergeArr[k] = L[i];
      i++;
      k++;
    }

    while (j < n2) {
      mergeArr[k] = R[j];
      j++;
      k++;
    }
  }

  //function to sort the list using HEAP SORT and repaint the canvas at every iteration.
  _heapSortVisualiser(List<int> heapArr) async {
    int n = heapArr.length;

    // Build heap (rearrange array)
    for (int i = n ~/ 2 - 1; i >= 0; i--) await heapify(heapArr, n, i);

    // One by one extract an element from heap
    for (int i = n - 1; i >= 0; i--) {
      // Move current root to end
      int temp = heapArr[0];
      heapArr[0] = heapArr[i];
      heapArr[i] = temp;
      await _updateArrayWithDelay(heapArr);
      // call max heapify on the reduced heap
      await heapify(heapArr, i, 0);
    }
  }

  heapify(List<int> heapArr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    // If left child is larger than root
    if (l < n && heapArr[l] > heapArr[largest]) largest = l;

    // If right child is larger than largest so far
    if (r < n && heapArr[r] > heapArr[largest]) largest = r;
    // If largest is not root
    if (largest != i) {
      int swap = heapArr[i];
      heapArr[i] = heapArr[largest];
      heapArr[largest] = swap;
      await _updateArrayWithDelay(heapArr);
      // Recursively heapify the affected sub-tree
      await heapify(heapArr, n, largest);
    }
  }

  ////function to sort the list using GNOME SORT and repaint the canvas at every iteration.
  _gnomeSortVisualiser() async {
    List<int> gnomeArr = List.from(arr);
    int index = 0;

    while (index < gnomeArr.length) {
      if (index == 0) index++;
      if (gnomeArr[index] >= gnomeArr[index - 1])
        index++;
      else {
        int temp;
        temp = gnomeArr[index];
        gnomeArr[index] = gnomeArr[index - 1];
        gnomeArr[index - 1] = temp;
        await Future.delayed(const Duration(microseconds: 800), () {
          setState(() {
            arr = List.from(gnomeArr);
          });
        });
        index--;
      }
    }
  }

  //async update method to keep the body of recursive algorithms cleaner.
  _updateArrayWithDelay(List<int> updatedArr) async {
    await Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        arr = List.from(updatedArr);
      });
    });
  }

  void _setAlgorithmRunningState(bool state) {
    setState(() {
      isAlgorithmRunning = state;
    });
  }

  //Helper function to get a list of random integers whose number depends on the physical width of working window.
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

//helper function to display a toast in the center of the screen
_showCenterToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blueAccent,
    textColor: Colors.white,
  );
}
