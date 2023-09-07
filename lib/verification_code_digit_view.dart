import 'package:flutter/material.dart';

class VerificationCodeDigitView extends StatefulWidget {
  const VerificationCodeDigitView({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  State<VerificationCodeDigitView> createState() =>
      _VerificationCodeDigitViewState();
}

class _VerificationCodeDigitViewState extends State<VerificationCodeDigitView> {
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        isFilled = widget.controller.text.isNotEmpty;
        if (isFilled) {
          FocusScope.of(context).nextFocus();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isFilled
                ? const Color.fromRGBO(0, 180, 125, 1)
                : const Color.fromRGBO(77, 84, 92, 1),
          ),
        ),
        counterText: '',
      ),
      textAlign: TextAlign.center,
      maxLength: 1,
      maxLines: 1,
    );
  }
}
