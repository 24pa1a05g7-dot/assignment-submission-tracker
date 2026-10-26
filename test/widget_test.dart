import 'package:assignment_submission_tracker/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('opens planner and assignment form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AssignmentTrackerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Planner').last);
    await tester.pumpAndSettle();

    expect(find.text('Your planner'), findsOneWidget);

    await tester.tap(find.text('Add assignment').first);
    await tester.pumpAndSettle();

    expect(find.text('Assignment title'), findsOneWidget);
    expect(find.text('Save assignment'), findsOneWidget);
  });
}