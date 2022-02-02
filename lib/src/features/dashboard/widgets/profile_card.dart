import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:overview/src/github/github_service.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:styleguide/styleguide.dart';

class ProfileCard extends StatelessWidget {
  ProfileCard({Key? key}) : super(key: key);

  final GithubService _githubService = getIt.get();

  User? get _user => _githubService.user;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _avatar(),
            login(),
          ],
        ),
      );

  Widget login() => SizedBox(
        width: 120,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingS),
          child: Text(
            _user?.login ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      );

  Widget _avatar() => ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusM),
        child: ExtendedImage.network(
          _user?.avatarUrl ?? "",
          cache: true,
          width: 120,
          fit: BoxFit.fill,
        ),
      );
}
