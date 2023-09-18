import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_cubit.dart';
import 'package:overview/src/features/dashboard/widgets/search_repos_field_with_suggestions.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:styleguide/styleguide.dart';

class RepositoryNameCard extends StatefulWidget {
  const RepositoryNameCard({Key? key}) : super(key: key);

  @override
  State<RepositoryNameCard> createState() => _RepositoryNameCardState();
}

class _RepositoryNameCardState extends State<RepositoryNameCard> {
  final RepositoryNameCubit _cubit = getIt();
  final TextEditingController _ownerEditingController = TextEditingController();
  final TextEditingController _repoEditingController = TextEditingController();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.loc().searchRepoName),
              const SizedBox(height: Dimensions.paddingS),
              _searchField(),
              const SizedBox(height: Dimensions.paddingM),
              Text(context.loc().repoOwnerAndName),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _repoOwnerField(context),
                  const SizedBox(width: Dimensions.paddingM),
                  _repoNameField(context),
                  const SizedBox(width: Dimensions.paddingXL),
                  _submitButton(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _repoOwnerField(BuildContext context) => SizedBox(
        width: 200,
        child: TextField(
          controller: _ownerEditingController,
          decoration: InputDecoration(
            labelText: context.loc().owner,
          ),
          onChanged: (value) {
            _cubit.onOwnerChanged(value);
          },
        ),
      );

  Widget _repoNameField(BuildContext context) => Container(
        constraints: const BoxConstraints(
          minWidth: 100,
          maxWidth: 300,
        ),
        child: TextField(
          controller: _repoEditingController,
          decoration: InputDecoration(
            labelText: context.loc().name,
          ),
          onChanged: (value) {
            _cubit.onNameChanged(value);
          },
        ),
      );

  Widget _searchField() =>
      BlocBuilder<RepositoryNameCubit, RepositoryNameState>(
        bloc: _cubit,
        builder: (context, state) => SearchReposFieldWithSuggestions(
          onChanged: (name) => _cubit.searchRepository(name),
          onSelected: (repo) => _cubit
            ..onNameChanged(repo.name)
            ..onOwnerChanged(repo.owner?.login ?? ''),
        ),
      );

  Widget _submitButton(BuildContext context) =>
      BlocConsumer<RepositoryNameCubit, RepositoryNameState>(
        bloc: _cubit,
        listener: (context, state) {
          if (_ownerEditingController.text != state.owner) {
            _ownerEditingController.text = state.owner ?? '';
          }
          if (_repoEditingController.text != state.name) {
            _repoEditingController.text = state.name ?? '';
          }
          if (state.error != null) {
            showErrorDialog(context, state.error!.message);
          }
        },
        builder: (context, state) => LoadingButton(
          text: context.loc().submit,
          onClick: _cubit.onSubmitClicked,
          isLoading: _cubit.state.isLoading,
        ),
      );
}
