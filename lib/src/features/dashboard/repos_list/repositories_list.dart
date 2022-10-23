import 'package:flutter/material.dart';
import 'package:styleguide/styleguide.dart';

class RepositoriesList extends StatelessWidget {
  const RepositoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppCard(
        child: SizedBox(
          height: 600,
          width: 120,
          child: ListView.separated(
            itemBuilder: (context, index) => _listItem(),
            //TODO: Change to proper data
            itemCount: 100,
            separatorBuilder: (BuildContext _, int __) => _separator(context),
          ),
        ),
      );

  Widget _listItem() => TextButton(
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingXS,
            vertical: Dimensions.paddingS,
          ),
          //TODO: Change to proper data
          child: Text('dataasa-sdasdas', textAlign: TextAlign.center),
        ),
        onPressed: () {},
      );

  Widget _separator(BuildContext context) => ColoredBox(
        color: context.bgColor(),
        child: const SizedBox(height: 1, width: double.infinity),
      );
}
