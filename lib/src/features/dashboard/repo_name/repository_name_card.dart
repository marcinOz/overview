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
                const SizedBox(height: Dimensions.paddingM),
                _searchField(),
                const SizedBox(height: Dimensions.paddingL),
                _buildFormSection(context),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
            const SizedBox(width: Dimensions.paddingXS),
            Text(
              context.loc().searchRepoName,
              style: context.titleSmallTextStyle().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        _buildPeriodSelector(),
      ],
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.source_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: Dimensions.paddingXS),
              Text(
                context.loc().repoOwnerAndName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingM),
          Wrap(
            spacing: Dimensions.paddingM,
            runSpacing: Dimensions.paddingM,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _repoOwnerField(context),
              _repoNameField(context),
              _submitButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return BlocBuilder<ChartPeriodCubit, PeriodSelectorData>(
      builder: (context, periodData) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingXS,
            vertical: 2,
          ),
          child: PeriodSelector(
            currentPeriod: periodData,
            onPeriodChanged: (newPeriod) {
              context.read<ChartPeriodCubit>().setPeriod(newPeriod);
            },
          ),
        );
      },
    );
  }

  Widget _searchField() =>
      BlocBuilder<RepositoryNameCubit, RepositoryNameState>(
        bloc: _repositoryNameCubit,
        builder: (context, state) => Container(
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingXS),
          child: SearchReposFieldWithSuggestions(
            onChanged: (name) => _repositoryNameCubit.searchRepository(name),
            onSelected: (repo) => _repositoryNameCubit
              ..onNameChanged(repo.name)
              ..onOwnerChanged(repo.owner?.login ?? ''),
          ),
        ),
      );

  Widget _repoOwnerField(BuildContext context) => SizedBox(
        width: 220,
        child: TextField(
          controller: _ownerController,
          decoration: InputDecoration(
            labelText: context.loc().owner,
            prefixIcon: Icon(
              Icons.account_circle_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: Dimensions.paddingS,
            ),
          ),
          onChanged: (value) {
            _repositoryNameCubit.onOwnerChanged(value);
          },
        ),
      );

  Widget _repoNameField(BuildContext context) => SizedBox(
        width: 220,
        child: TextField(
          controller: _repoController,
          decoration: InputDecoration(
            labelText: context.loc().name,
            prefixIcon: Icon(
              Icons.folder_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: Dimensions.paddingS,
            ),
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
