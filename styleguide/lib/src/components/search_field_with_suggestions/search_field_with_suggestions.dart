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
  Widget build(BuildContext context) => SizedBox(
        width: 300,
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
          border: const OutlineInputBorder(),
          labelText: widget.hintText,
          icon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child:
                _isSearching ? _circularProgress() : const Icon(Icons.search),
          ),
        ),
        onChanged: (value) {
          setState(() => _isSearching = value.isNotEmpty);
        },
      );

  Padding _circularProgress() => const Padding(
        padding: EdgeInsets.only(top: Dimensions.paddingM),
        child: SizedBox(
          height: Dimensions.paddingM,
          width: Dimensions.paddingM,
          child: CircularProgressIndicator(),
        ),
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
