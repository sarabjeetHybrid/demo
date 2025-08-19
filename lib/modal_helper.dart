import 'package:demo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalHelper {

static Future<bool> askForInput(
    String title,
    String message,
    String positiveButton,
    String negativeButton,
    bool showOnlyOneButton) async {
    return await showCupertinoDialog(
    context: navigatorKey.currentState!.context,
    // Use the global navigator key
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(width: 3.0, color: Colors.red[200]!),
      ),
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          const Center(
              child: Icon(
            Icons.warning,
            color: Colors.red,
            size: 35,
          )),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: !showOnlyOneButton
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 180,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[300]),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text(
                  negativeButton,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!showOnlyOneButton)
              GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red[300]!, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    positiveButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
}
