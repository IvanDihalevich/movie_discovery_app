import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_discovery_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Movie Discovery App Integration Tests', () {
    testWidgets('Complete app flow test', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify app title is displayed
      expect(find.text('Movie Discovery'), findsOneWidget);

      // Wait for initial loading to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home page elements are present
      expect(find.text('Popular Movies'), findsOneWidget);

      // Test search functionality
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verify search page opened (if implemented)
      // This test will be updated when search feature is implemented

      // Test pull-to-refresh
      await tester.fling(find.byType(ListView), const Offset(0, 500), 1000);
      await tester.pumpAndSettle();

      // Verify refresh completed
      expect(find.text('Popular Movies'), findsOneWidget);
    });

    testWidgets('Navigation test', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for initial loading
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test if movie cards are tappable
      final movieCards = find.byType(GestureDetector);
      if (movieCards.evaluate().isNotEmpty) {
        await tester.tap(movieCards.first);
        await tester.pumpAndSettle();

        // Verify navigation to movie details (when implemented)
        // This test will be updated when movie details feature is implemented
      }
    });

    testWidgets('Performance test', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Measure frame rendering time
      final binding = tester.binding;
      final stopwatch = Stopwatch()..start();

      // Perform some UI interactions
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      stopwatch.stop();
      
      // Verify performance is acceptable (less than 100ms for 10 frames)
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
