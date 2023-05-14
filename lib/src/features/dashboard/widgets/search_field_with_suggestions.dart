import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overview/src/localization/localizations.dart';

class SearchFieldWithSuggestions extends StatefulWidget {
  const SearchFieldWithSuggestions({
    Key? key,
    required this.onChanged,
    required this.onSelected,
  }) : super(key: key);

  final Future<List<String>> Function(String) onChanged;
  final void Function(String) onSelected;

  @override
  State<SearchFieldWithSuggestions> createState() =>
      _SearchFieldWithSuggestionsState();
}

class _SearchFieldWithSuggestionsState
    extends State<SearchFieldWithSuggestions> {
  Timer? _debounce;
  List<String> suggestions = [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 300,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return suggestions.where(
              (suggestion) =>
                  suggestion.contains(textEditingValue.text.toLowerCase()),
            );
          },
          onSelected: (String selection) {
            widget.onSelected(suggestions.firstWhere(
              (element) => element == selection,
            ));
          },
          fieldViewBuilder: _textField,
          optionsViewBuilder: _dropdown,
        ),
      );

  TextField _textField(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) =>
      TextField(
        controller: textEditingController,
        focusNode: focusNode,
        decoration: InputDecoration(hintText: context.loc().name),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () async {
            final list = await widget.onChanged(value);
            setState(() {
              suggestions = list;
            });
          });
        },
      );

  Widget _dropdown(
    BuildContext context,
    AutocompleteOnSelected<String> onSelected,
    Iterable<String> options,
  ) =>
      _DropDown(options: options.toList(), onSelected: onSelected);
}

class _DropDown extends StatelessWidget {
  const _DropDown({
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
