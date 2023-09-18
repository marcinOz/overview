import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  const DropDown({
    Key? key,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  final List<String> options;
  final AutocompleteOnSelected<String> onSelected;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: Material(
      elevation: 4.0,
      child: SizedBox(
        width: 300,
        height: 400,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) {
            final String option = options.elementAt(index);
            return GestureDetector(
              onTap: () {
                onSelected(option);
              },
              child: ListTile(
                title: Text(option),
              ),
            );
          },
        ),
      ),
    ),
  );
}
