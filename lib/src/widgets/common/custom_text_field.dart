
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {

  final Function(String) onSubmitted;
  final Function(String) onChanged;
  final String initialText;
  final String hint;
  CustomTextField({
    @required this.initialText,
    @required this.hint,
    @required this.onSubmitted,
    @required this.onChanged,
  });

  @override
  State createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    Future.delayed(Duration.zero, () {
      _controller.text = widget.initialText;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    textAlign: TextAlign.left,
    decoration: InputDecoration(
      hintText: widget.hint
    ),
    onSubmitted: widget.onSubmitted,
    onChanged: widget.onChanged
  );
}