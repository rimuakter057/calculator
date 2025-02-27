import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../widget/information_input_field.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightFController = TextEditingController();
  TextEditingController heightIController = TextEditingController();
  double result = 0;
  Widget gap = const SizedBox(height: 20,);

  // List to hold the selected rows
  List<int> selectedRows = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    InformationInputField(
                      controller: weightController,
                      title: "weight",
                    ),
                    gap,
                    InformationInputField(
                      controller: heightFController,
                      title: "feet",
                    ),
                    gap,
                    InformationInputField(
                      controller: heightIController,
                      title: "inches",
                    ),
                  ],
                ),
              ),
              gap,
              gap,
              ElevatedButton(
                onPressed: () {
                  bmiCalculate();
                },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize: Size.fromWidth(double.maxFinite),
                    backgroundColor: Colors.red.shade900),
                child: Text(
                  "Click",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              gap,
              gap,
              // BMI UI
              SfRadialGauge(
                title: const GaugeTitle(
                    text: 'Calculate BMI',
                    textStyle: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 16,
                    maximum: 39.9,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 16,
                          endValue: 18.4,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 18.5,
                          endValue: 24.9,
                          color: Colors.orange,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 25.0,
                          endValue: 29.9,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 30.0,
                          endValue: 34.9,
                          color: Colors.deepPurpleAccent,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 35.0,
                          endValue: 39.9,
                          color: Colors.greenAccent,
                          startWidth: 10,
                          endWidth: 10),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: result)
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                result.toStringAsFixed(2),
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              if (result < 16)
                                Text(
                                  "Too Low!",
                                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              if (result >= 40)
                                Text(
                                  "Too High!",
                                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      )
                    ],
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    showBmiDialog(result);
                    print("Success");
                  },
                  child: Text("Show BMI")
              )
            ],
          ),
        ),
      ),
    );
  }

  bmiCalculate() {
    double? weight = double.tryParse(weightController.text);
    double? heightF = double.tryParse(heightFController.text);
    double? heightI = double.tryParse(heightIController.text);

    // Check if both heightF and heightI are provided
    if (heightF != null && heightI != null && weight != null) {
      double meter = (heightF * 12 + heightI) * 0.0254; // Convert feet and inches to meters
      result = weight / (meter * meter); // BMI Calculation
      setState(() {});
    } else {
      // Handle error when input is invalid
      result = 0;
      setState(() {});
    }
  }

  void showBmiDialog(double result) {
    Get.dialog(
      AlertDialog(
        title: Text("BMI Chart"),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('BMI Value', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Health Status', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: [
              _bmiRow(result, 0, '< 16', 'Severe Thinness', 16),
              _bmiRow(result, 1, '16 - 16.9', 'Moderate Thinness', 16.9),
              _bmiRow(result, 2, '17 - 18.4', 'Mild Thinness', 18.4),
              _bmiRow(result, 3, '18.5 - 24.9', 'Normal', 24.9),
              _bmiRow(result, 4, '25 - 29.9', 'Overweight', 29.9),
              _bmiRow(result, 5, '30 - 34.9', 'Obese Class 1', 34.9),
              _bmiRow(result, 6, '35 - 39.9', 'Obese Class 2', 39.9),
              _bmiRow(result, 7, '≥ 40', 'Obese Class 3', double.infinity),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  DataRow _bmiRow(double result, int index, String range, String status, double max) {
    bool isSelected = selectedRows.contains(index); // Check if the row is selected
    Color rowColor = isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent;

    return DataRow(
      selected: isSelected, // This marks the row as selected
      onSelectChanged: (selected) {
        if (selected != null) {
          toggleRowSelection(index); // Toggle row selection
        }
      },
      color: WidgetStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        return rowColor; // Highlight the row if selected
      }),
      cells: [
        DataCell(Text(range)),
        DataCell(Text(status)),
      ],
    );
  }

  void toggleRowSelection(int rowIndex) {
    setState(() { // Call setState to trigger a rebuild and update UI
      if (selectedRows.contains(rowIndex)) {
        selectedRows.remove(rowIndex); // If already selected, deselect it
      } else {
        if (selectedRows.length < 2) {
          selectedRows.add(rowIndex); // Add row to selection if less than 2 selected
        }
      }
    });
  }


  void clearControllers() {
    weightController.clear();
    heightFController.clear();
    heightIController.clear();
  }
}
