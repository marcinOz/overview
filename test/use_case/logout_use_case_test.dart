import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:overview/src/features/login/login_view.dart';
import 'package:overview/src/github/github_service.dart';
import 'package:overview/src/injectable/injectable.dart';
import 'package:overview/src/use_case/logout_use_case.dart';

class MockGithubService extends Mock implements GithubService {}

void main() {
  group('LogoutUseCase', () {
    late LogoutUseCase useCase;
    late MockGithubService githubService;

    setUp(() {
      useCase = LogoutUseCase();
      githubService = MockGithubService();
      getIt.registerSingleton<GithubService>(githubService);
    });

    testWidgets('should call logout on GithubService & navigate to LoginView',
        (WidgetTester tester) async {
      BuildContext? ctx;
      final loginViewKey = UniqueKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              ctx = context;
              return Container();
            },
          ),
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case LoginView.routeName:
                    return Container(key: loginViewKey);
                  default:
                    return Container();
                }
              },
            );
          },
        ),
      );

      useCase(ctx!);

      verify(githubService.logout()).called(1);

      await tester.pumpAndSettle();

      expect(find.byKey(loginViewKey), findsOneWidget);
    });
  });
}
