import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github/github.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_cubit.dart';
import 'package:overview/src/features/dashboard/repos_list/repositories_list_cubit.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:styleguide/styleguide.dart';

class RepositoriesList extends StatefulWidget {
  const RepositoriesList({Key? key}) : super(key: key);

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
}

class _RepositoriesListState extends State<RepositoriesList> {
  final RepositoriesListCubit _cubit = getIt();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppCard(
        child: SizedBox(
          height: 600,
          width: 120,
          child: BlocConsumer<RepositoriesListCubit, RepositoriesListState>(
            bloc: _cubit,
            listener: (context, state) {},
            buildWhen: (previous, current) =>
                current is RepositoriesListPopulatedState,
            builder: (context, state) => ListView.separated(
              itemCount: state is RepositoriesListPopulatedState
                  ? state.list.length
                  : 0,
              itemBuilder: (context, index) => _listItem(
                  (state as RepositoriesListPopulatedState).list[index]),
              separatorBuilder: (BuildContext _, int __) => _separator(context),
            ),
          ),
        ),
      );

  Widget _listItem(Repository repo) => TextButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingXS,
            vertical: Dimensions.paddingS,
          ),
          child: Text(repo.name, textAlign: TextAlign.center),
        ),
        onPressed: () {
          getIt
              .get<RepositoryNameCubit>()
              .fillUpFromClick(repo.owner!.login, repo.name);
        },
      );

  Widget _separator(BuildContext context) => ColoredBox(
        color: context.bgColor(),
        child: const SizedBox(height: 1, width: double.infinity),
      );
}
