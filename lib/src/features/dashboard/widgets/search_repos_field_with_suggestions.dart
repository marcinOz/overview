import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:styleguide/styleguide.dart';

class SearchReposFieldWithSuggestions extends StatefulWidget {
  const SearchReposFieldWithSuggestions({
    Key? key,
    required this.onChanged,
    required this.onSelected,
  }) : super(key: key);

  final Future<List<Repository>> Function(String) onChanged;
  final void Function(Repository) onSelected;

  @override
  State<SearchReposFieldWithSuggestions> createState() =>
      _SearchReposFieldWithSuggestionsState();
}

class _SearchReposFieldWithSuggestionsState
    extends State<SearchReposFieldWithSuggestions> {
  List<Repository> suggestions = [];

  @override
  Widget build(BuildContext context) => SearchFieldWithSuggestions(
        hintText: context.loc().repoName,
        onChanged: (name) async {
          suggestions = await widget.onChanged(name);
          return suggestions.map((e) => e.fullName).toList();
        },
        onSelected: (name) {
          widget.onSelected(
            suggestions.firstWhere((element) => element.fullName == name),
          );
        },
      );
}
