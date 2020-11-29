
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTextField extends HookWidget {

  final Function(String) onSubmitted;
  final Function(String) onChanged;
  final Function onClear;
  final String initialText;
  final String hint;
  CustomTextField({
    @required this.initialText,
    @required this.hint,
    @required this.onChanged,
    this.onClear,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    var controller = useTextEditingController(text: initialText);
    return TextField(
      controller: controller,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          iconSize: 20,
          icon: Icon(Icons.clear),
          color: Colors.white,
          onPressed: () {
            controller.clear();
            if (onClear != null) {
              onClear();
            }
          },
        )
      ),
      onSubmitted: onSubmitted,
      onChanged: onChanged
    );
  }
}