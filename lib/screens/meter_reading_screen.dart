import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/time.dart';

class MeterReadingScreen extends StatefulWidget {
  const MeterReadingScreen({super.key});

  @override
  State<MeterReadingScreen> createState() => _MeterReadingScreenState();
}

class _MeterReadingScreenState extends State<MeterReadingScreen> {
    List<TextEditingController> controllers =
      List.generate(5, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(3, (_) => FocusNode());
  int currentFocusIndex = 0;

  @override
  void initState() {
    super.initState();
    focusNodes[0].addListener(() => setState(() => currentFocusIndex = 0));
    focusNodes[1].addListener(() => setState(() => currentFocusIndex = 1));
    focusNodes[2].addListener(() => setState(() => currentFocusIndex = 2));
    controllers[0].addListener(_updateValues);
    controllers[1].addListener(_updateValues);
    controllers[3].addListener(_updateValues);
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateValues() {
    setState(() {
      double value1 = double.tryParse(controllers[0].text) ?? 0.0;
      double value2 = double.tryParse(controllers[1].text) ?? 0.0;
      double value4 = double.tryParse(controllers[3].text) ?? 1.0;

      controllers[2].text = (value2 - value1).toString();
      controllers[4].text =
          (value1 != 0.0 ? (value2 - value1) / value4 : 0.0).toString();
    });
  }

  void _resetFields() {
    setState(() {
      for (var ctl in controllers) {
        ctl.clear();
      }
      currentFocusIndex = 0;
      FocusScope.of(context).requestFocus(focusNodes[currentFocusIndex]);
    });
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      {bool readOnly = false, FocusNode? focusNode, Color? color}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            readOnly: readOnly,
            showCursor: !readOnly,
            enableInteractiveSelection: !readOnly,
            keyboardType: TextInputType.none,
            inputFormatters: readOnly
                ? []
                : [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 245, 240, 251),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 158, 158, 158), width: 1.0),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: Colors
                  .white, // Ensure the background is white to cover the TextField
              child: Text(
                labelText,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateFields(bool forward) {
    setState(() {
      if (forward) {
        currentFocusIndex = (currentFocusIndex + 1) % 3;
      } else {
        currentFocusIndex = (currentFocusIndex - 1 + 3) % 3;
      }
      FocusScope.of(context).requestFocus(focusNodes[currentFocusIndex]);
    });
  }

  void _updateTextFieldValue(String value) {
    setState(() {
      if (currentFocusIndex == 0) {
        controllers[0].text += value;
      } else if (currentFocusIndex == 1) {
        controllers[1].text += value;
      } else if (currentFocusIndex == 2) {
        controllers[3].text += value;
      }
    });
  }

  void _deleteTextFieldValue() {
    setState(() {
      if (currentFocusIndex == 0 && controllers[0].text.isNotEmpty) {
        controllers[0].text =
            controllers[0].text.substring(0, controllers[0].text.length - 1);
      } else if (currentFocusIndex == 1 && controllers[1].text.isNotEmpty) {
        controllers[1].text =
            controllers[1].text.substring(0, controllers[1].text.length - 1);
      } else if (currentFocusIndex == 2 && controllers[3].text.isNotEmpty) {
        controllers[3].text =
            controllers[3].text.substring(0, controllers[3].text.length - 1);
      }
    });
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 15),
            Row(
              children: [
                Time(),
                const SizedBox(width: 50),
                Expanded(
                    child: buildTextField(controllers[4], 'CONSUMPTION:km/l',
                        readOnly: true, color: const Color(0xff34b734))),
              ],
            ),
            const SizedBox(height: 5),
            buildTextField(controllers[0], 'PREVIOUS ODO/km',
                focusNode: focusNodes[0]),
            const SizedBox(height: 5),
            buildTextField(controllers[1], 'Final ODO/km',
                focusNode: focusNodes[1]),
            const SizedBox(height: 5),
            buildTextField(controllers[2], 'DISTANCE TRAVELLED/km',
                readOnly: true, color: const Color(0xff6c0c22)),
            const SizedBox(height: 5),
            buildTextField(controllers[3], 'ISSUED FUEL/l',
                focusNode: focusNodes[2], color: const Color(0xff34b734)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _navigateFields(false),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff6c0c22)),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      )),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () => _resetFields(),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff34b734)),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      )),
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () => _navigateFields(true),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff6c0c22)),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      )),
                  child: const Text('Next'),
                ),
                ElevatedButton(
                  onPressed: () => _navigateFields(true),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff6c0c22)),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      )),
                  child: const Text('+'),
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 2,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                String text;
                VoidCallback onPressed;

                if (index < 9) {
                  text = (index + 1).toString();
                  onPressed = () => _updateTextFieldValue(text);
                } else if (index == 9) {
                  text = ".";
                  onPressed = () => _updateTextFieldValue(text);
                } else if (index == 10) {
                  text = "0";
                  onPressed = () => _updateTextFieldValue(text);
                } else {
                  text = "⌫";
                  onPressed = _deleteTextFieldValue;
                }

                return ElevatedButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  )),
                  child: Text(text),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
