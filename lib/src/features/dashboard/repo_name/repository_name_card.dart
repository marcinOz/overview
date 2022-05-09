import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overview/src/features/dashboard/repo_name/repository_name_cubit.dart';
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
  void initState() {
    const prefillOwner = 'netguru';
    const prefillRepo = 'cashcow-flutter';
    _ownerEditingController.text = prefillOwner;
    _cubit.onOwnerChanged(prefillOwner);
    _repoEditingController.text = prefillRepo;
    _cubit.onNameChanged(prefillRepo);
    super.initState();
  }

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
              Text(context.loc().repoOwnerAndName),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
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
                  ),
                  const SizedBox(width: Dimensions.paddingM),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _repoEditingController,
                      decoration: InputDecoration(
                        labelText: context.loc().name,
                      ),
                      onChanged: (value) {
                        _cubit.onNameChanged(value);
                      },
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingXL),
                  _submitButton(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _submitButton(BuildContext context) =>
      BlocConsumer<RepositoryNameCubit, RepositoryNameState>(
        bloc: _cubit,
        listener: (context, state) {
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
