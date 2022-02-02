import 'package:flutter/material.dart';
import 'package:styleguide/src/dimensions.dart';


class AppCard extends StatelessWidget {
  const AppCard({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
    ),
    child: child,
  );
}
