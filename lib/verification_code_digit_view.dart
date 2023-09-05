import 'package:flutter/material.dart';

class VerificationCodeDigitView extends StatefulWidget {
  const VerificationCodeDigitView({super.key});

  @override
  State<VerificationCodeDigitView> createState() =>
      _VerificationCodeDigitViewState();
}

class _VerificationCodeDigitViewState extends State<VerificationCodeDigitView> {
  bool isFilled = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      onChanged: (digit) {
        setState(() {
          isFilled = digit.isNotEmpty;
        });
      },
    );
  }
}
