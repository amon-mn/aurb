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
    this.initialValue, // Adicione esta linha
  }) : super(key: key) {
    if (initialValue != null) {
      controller.text = initialValue!; // Defina o valor inicial do controlador
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

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        style: TextStyle(fontSize: 16 * textScaleFactor),
        inputFormatters:
            widget.inputFormatter != null ? [widget.inputFormatter!] : [],
        controller: widget.controller,
        obscureText: widget
            .obscureText, // Use o valor fornecido pela propriedade obscureText
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Color.fromARGB(255, 0, 90, 3),
          ),
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  color: Color.fromARGB(255, 0, 90, 3),
                  onPressed: widget
                      .onSuffixIconPressed, // Chame a função fornecida aqui
                )
              : null,
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 103, 3)),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15.0),
          ),
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: isFilled ? null : widget.hintText,
          labelText: isFilled || isInvalid ? widget.hintText : null,
          labelStyle: TextStyle(
            color: isInvalid ? Colors.red : Colors.green[800],
          ),
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
          widget.onChanged
              ?.call(value); // Chame a função onChanged se estiver definida
        },
      ),
    );
  }
}
