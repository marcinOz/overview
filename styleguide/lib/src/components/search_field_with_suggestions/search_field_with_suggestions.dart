import 'dart:async';

import 'package:flutter/material.dart';
import 'package:styleguide/styleguide.dart';

import 'drop_down.dart';

class SearchFieldWithSuggestions extends StatefulWidget {
  const SearchFieldWithSuggestions({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.onSelected,
  }) : super(key: key);

  final String hintText;
  final Future<List<String>> Function(String) onChanged;
  final void Function(String) onSelected;

  @override
  State<SearchFieldWithSuggestions> createState() =>
      _SearchFieldWithSuggestionsState();
}

class _SearchFieldWithSuggestionsState
    extends State<SearchFieldWithSuggestions> {
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: Autocomplete<String>(
          optionsBuilder: _optionsBuilder,
          onSelected: widget.onSelected,
          fieldViewBuilder: _textField,
          optionsViewBuilder: (context, onSelected, options) =>
              DropDown(options: options.toList(), onSelected: onSelected),
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
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: Dimensions.paddingM,
          ),
          labelText: widget.hintText,
          prefixIcon: Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(10),
            child: _isSearching
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Icon(
                    Icons.search,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
          ),
        ),
        onChanged: (value) {
          setState(() => _isSearching = value.isNotEmpty);
        },
      );

  FutureOr<Iterable<String>> _optionsBuilder(
    TextEditingValue textEditingValue,
  ) async {
    final list = await _getSuggestions(textEditingValue.text);
    if (list.isEmpty) {
      return const Iterable<String>.empty();
    }
    return list;
  }

  Future<List<String>> _getSuggestions(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (text.isEmpty) return Future.value([]);

    final debounceCompleter = Completer<List<String>>();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final list = await widget.onChanged(text);
      setState(() => _isSearching = false);
      debounceCompleter.complete(list);
    });
    return debounceCompleter.future;
  }
}
