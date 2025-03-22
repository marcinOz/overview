import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:overview/src/features/dashboard/avg/chart_parts/period_selector.dart';
import 'package:overview/src/features/dashboard/chart_period/chart_period_cubit.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_cubit.dart';
import 'package:overview/src/features/dashboard/widgets/search_repos_field_with_suggestions.dart';
import 'package:overview/src/localization/localizations.dart';
import 'package:styleguide/styleguide.dart';

class RepositoryNameCard extends StatefulWidget {
  const RepositoryNameCard({Key? key}) : super(key: key);

  @override
  State<RepositoryNameCard> createState() => _RepositoryNameCardState();
}

class _RepositoryNameCardState extends State<RepositoryNameCard> {
  final _repositoryNameCubit = GetIt.I<RepositoryNameCubit>();
  final _ownerController = TextEditingController();
  final _repoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ownerController.text = _repositoryNameCubit.state.owner ?? '';
    _repoController.text = _repositoryNameCubit.state.name ?? '';
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _repoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width - 178,
        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingM),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: Dimensions.paddingS),
                _searchField(),
                const SizedBox(height: Dimensions.paddingM),
                Text(context.loc().repoOwnerAndName),
                Wrap(
                  runSpacing: Dimensions.paddingM,
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
        ),
      );

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(context.loc().searchRepoName),
        _buildPeriodSelector(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return BlocBuilder<ChartPeriodCubit, PeriodSelectorData>(
      builder: (context, periodData) {
        return PeriodSelector(
          currentPeriod: periodData,
          onPeriodChanged: (newPeriod) {
            context.read<ChartPeriodCubit>().setPeriod(newPeriod);
          },
        );
      },
    );
  }

  Widget _searchField() =>
      BlocBuilder<RepositoryNameCubit, RepositoryNameState>(
        bloc: _repositoryNameCubit,
        builder: (context, state) => SearchReposFieldWithSuggestions(
          onChanged: (name) => _repositoryNameCubit.searchRepository(name),
          onSelected: (repo) => _repositoryNameCubit
            ..onNameChanged(repo.name)
            ..onOwnerChanged(repo.owner?.login ?? ''),
        ),
      );

  Widget _repoOwnerField(BuildContext context) => SizedBox(
        width: 200,
        child: TextField(
          controller: _ownerController,
          decoration: InputDecoration(
            labelText: context.loc().owner,
          ),
          onChanged: (value) {
            _repositoryNameCubit.onOwnerChanged(value);
          },
        ),
      );

  Widget _repoNameField(BuildContext context) => Container(
        constraints: const BoxConstraints(
          minWidth: 100,
          maxWidth: 300,
        ),
        child: TextField(
          controller: _repoController,
          decoration: InputDecoration(
            labelText: context.loc().name,
          ),
          onChanged: (value) {
            _repositoryNameCubit.onNameChanged(value);
          },
        ),
      );

  Widget _submitButton(BuildContext context) =>
      BlocConsumer<RepositoryNameCubit, RepositoryNameState>(
        bloc: _repositoryNameCubit,
        listener: (context, state) {
          if (_ownerController.text != state.owner) {
            _ownerController.text = state.owner ?? '';
          }
          if (_repoController.text != state.name) {
            _repoController.text = state.name ?? '';
          }
          if (state.error != null) {
            showErrorDialog(context, state.error!.message);
          }
        },
        builder: (context, state) => LoadingButton(
          text: context.loc().submit,
          onClick: _repositoryNameCubit.onSubmitClicked,
          isLoading: _repositoryNameCubit.state.isLoading,
        ),
      );
}
