import 'package:flutter/material.dart';

import '../../styleguide.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.onClick,
    required this.text,
  }) : super(key: key);

  final String text;
  final bool isLoading;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
            child: ElevatedButton(
              onPressed: isLoading ? null : onClick,
              child: Text(text),
            ),
          ),
          if (isLoading)
            const Positioned(
              top: Dimensions.paddingXS,
              left: Dimensions.paddingL,
              right: Dimensions.paddingL,
              child: SizedBox(
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
}
