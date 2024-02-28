import 'package:flutter/material.dart';

class MyDropdownFormField extends StatelessWidget {
  final ValueNotifier<String> selectedValueNotifier;
  final List<String>? itemsList;
  final String? labelText;
  final IconData? prefixIcon;
  final String? hint;
  final Function(String?)? onChanged;

  MyDropdownFormField({
    required this.selectedValueNotifier,
    this.itemsList,
    required this.onChanged,
    this.labelText,
    this.prefixIcon,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedValueNotifier,
      builder: (context, selectedValue, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 57.0,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedValue,
            items: itemsList
                ?.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                })
                .toSet()
                .toList(),
            onChanged: onChanged,
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: Color.fromARGB(255, 32, 32, 32),
            ),
            dropdownColor: Colors.grey[100],
            decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                color: const Color.fromARGB(255, 69, 69, 69),
              ),
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromRGBO(238, 238, 238, 1)),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 0, 103, 3)),
                borderRadius: BorderRadius.circular(15.0),
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
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
