// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:plastic_usage/api_utils.dart';
import 'package:plastic_usage/main.dart';

void main() {
  testWidgets('shows the plastic usage tracker', (WidgetTester tester) async {
    await tester.pumpWidget(const PlasticUsageTracker());

    // Verify that the plastic usage tracker is displayed.
    expect(find.text('Plastic Usage Tracker'), findsOneWidget);
    expect(find.text('PLASTIC USAGE TRACKER'), findsOneWidget);

    // Additional checks can be added here if necessary.
  });

  test('handles empty or malformed API responses safely', () {
    expect(parseApiResponse(''), {
      'success': false,
      'message': 'No response from server',
    });

    expect(parseApiResponse('<html>not json</html>'), {
      'success': false,
      'message': 'Invalid server response',
    });

    expect(apiResponseSucceeded({'success': true}), isTrue);
    expect(apiResponseSucceeded({'success': 1}), isTrue);
    expect(apiResponseSucceeded({'success': 'true'}), isTrue);
    expect(apiResponseSucceeded({'success': false}), isFalse);
  });
}
