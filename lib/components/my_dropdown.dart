import 'package:flutter/material.dart';

class MyDropdownFormField extends StatelessWidget {
  final ValueNotifier<String> selectedValueNotifier;
  final List<String>? itemsList;
  final String? labelText;
  final String? hint;
  final Function(String?)? onChanged;

  MyDropdownFormField({
    required this.selectedValueNotifier,
    this.itemsList,
    required this.onChanged,
    this.labelText,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedValueNotifier,
      builder: (context, selectedValue, child) {
        return DropdownButtonFormField<String>(
          isExpanded: true,
          itemHeight: 48, // Adjust the height of each item
          iconSize: 24, // Adjust the icon size
          value: selectedValue,
          items: itemsList
              ?.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16), // Adjust the horizontal padding
                        child: Text(item),
                      ),
                    ],
                  ),
                );
              })
              .toSet()
              .toList(),
          onChanged: onChanged,
          icon: const Icon(
            Icons.arrow_drop_down_circle,
            color: Color.fromARGB(255, 89, 89, 89),
          ),
          dropdownColor: Colors.grey[100],
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding
            border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
              borderRadius: BorderRadius.zero,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 124, 124, 124)),
              borderRadius: BorderRadius.zero,
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            labelText: labelText,
            hintText: hint,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.zero,
            ),
          ),
        );
      },
    );
  }
}
