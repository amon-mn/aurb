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
  final TextInputType? keyboardType;
  final FocusNode? focusNode; // Novo parâmetro

  MyTextFieldWrapper({
    super.key,
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
    this.keyboardType,
    this.focusNode, // Inicializa o novo parâmetro
  }) {
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
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        maxLines: null,
        style: TextStyle(fontSize: 16 * textScaleFactor),
        inputFormatters:
            widget.inputFormatter != null ? [widget.inputFormatter!] : [],
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode, // Atribui o FocusNode
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefixIcon,
            color: const Color.fromARGB(255, 69, 69, 69),
          ),
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  color: const Color.fromARGB(255, 69, 69, 69),
                  onPressed: widget.onSuffixIconPressed,
                )
              : null,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromRGBO(49, 28, 28, 1)),
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
