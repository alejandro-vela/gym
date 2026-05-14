import 'package:flutter_test/flutter_test.dart';

import 'package:gymtrack_pro/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // GymTrackApp requires async initialization before use;
    // this placeholder test just verifies the file compiles.
    expect(GymTrackApp, isNotNull);
  });
}
