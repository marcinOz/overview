import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:styleguide/styleguide.dart';

class ContributorProfileCard extends StatelessWidget {
  const ContributorProfileCard({
    Key? key,
    required this.contributor,
    required this.isSelected,
    required this.onTap,
    this.width = 100,
  }) : super(key: key);

  final Contributor contributor;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingXS),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
            ),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _avatar(context),
                  _login(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _login(BuildContext context) => Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingS,
          vertical: Dimensions.paddingXS,
        ),
        child: Text(
          contributor.login ?? "",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).primaryColor : null,
          ),
        ),
      );

  Widget _avatar(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ExtendedImage.network(
              contributor.avatarUrl ?? "",
              cache: true,
              width: width,
              height: width,
              fit: BoxFit.cover,
            ),
            if (isSelected)
              Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: width / 3,
                ),
              ),
          ],
        ),
      );
}

// Special "All" contributor card that matches the style of other contributor cards
class AllContributorsCard extends StatelessWidget {
  const AllContributorsCard({
    Key? key,
    required this.isSelected,
    required this.onTap,
    this.width = 100,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingXS),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
            ),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _avatar(context),
                  _label(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context) => Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingS,
          vertical: Dimensions.paddingXS,
        ),
        child: Text(
          "All",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).primaryColor : null,
          ),
        ),
      );

  Widget _avatar(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: width,
              height: width,
              color: Theme.of(context).colorScheme.background,
              child: Icon(
                Icons.people_alt_rounded,
                size: width / 2,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
            if (isSelected)
              Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: width / 3,
                ),
              ),
          ],
        ),
      );
}
