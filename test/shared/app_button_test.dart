import 'package:flutter/material.dart';
import 'package:flutter_template/shared/widgets/atoms/app_button.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('renders its label and calls onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(AppButton(label: 'Save', onPressed: () => taps++)),
    );

    await tester.tap(find.text('Save'));

    expect(taps, 1);
  });

  testWidgets('shows a spinner and ignores taps while loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(AppButton(label: 'Save', isLoading: true, onPressed: () => taps++)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets('uses an OutlinedButton for the outlined variant', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.outlined,
          onPressed: () {},
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });
}
