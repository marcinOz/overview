flutter test --coverage
lcov --remove coverage/lcov.info '**/*.freezed.dart' '**/*.g.dart' -o coverage/new_lcov.info genhtml coverage/new_lcov.info --output=coverage -o coverage/html open coverage/html/index.html
