import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyTextFieldWrapper extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final MaskTextInputFormatter? inputFormatter;
  final VoidCallback? onSuffixIconPressed;
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  MyTextFieldWrapper({
    Key? key,
    required this.controller,
    this.hintText,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.inputFormatter,
    this.onSuffixIconPressed,
    this.onChanged,
    this.initialValue,
  }) : super(key: key) {
    if (initialValue != null) {
      controller.text = initialValue!;
    }
  }

  @override
  _MyTextFieldWrapperState createState() => _MyTextFieldWrapperState();
}

class _MyTextFieldWrapperState extends State<MyTextFieldWrapper> {
  bool isFilled = false;
  bool isInvalid = false;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 2), // Ajuste o valor de horizontal conforme necessário
      child: TextFormField(
        style: TextStyle(fontSize: 16 * textScaleFactor),
        inputFormatters:
            widget.inputFormatter != null ? [widget.inputFormatter!] : [],
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Color.fromARGB(255, 0, 90, 3),
          ),
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  color: Color.fromARGB(255, 0, 90, 3),
                  onPressed: widget.onSuffixIconPressed,
                )
              : null,
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 103, 3)),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(16.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(16.0),
          ),
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: isFilled ? null : widget.hintText,
          labelText: isFilled || isInvalid ? widget.hintText : null,
          labelStyle: TextStyle(
            color: isInvalid ? Colors.red : Colors.green[800],
          ),
          contentPadding: EdgeInsets.zero,
        ),
        validator: (value) {
          final validationError = widget.validator?.call(value);
          setState(() {
            isInvalid = validationError != null;
          });
          return validationError;
        },
        onChanged: (value) {
          setState(() {
            isFilled = value.isNotEmpty;
          });
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
