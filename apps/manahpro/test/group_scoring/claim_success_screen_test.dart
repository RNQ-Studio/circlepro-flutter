import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/claim_success_summary.dart';
import 'package:manahpro/features/group_scoring/presentation/screens/claim_success_screen.dart';

/// Sprint 15.3 — the claim-success screen welcomes a freshly-approved archer
/// with their first PB / average / a training invitation, never a bare
/// "berhasil". Tone is club-practice warm (15.4), never a competition result.
void main() {
  Future<void> pumpScreen(WidgetTester tester, ClaimSuccessSummary summary) {
    return tester.pumpWidget(MaterialApp(
      home: ClaimSuccessScreen(
        groupId: 'grp1',
        sessionId: 'sess1',
        summary: summary,
      ),
    ));
  }

  testWidgets('a first PB celebrates the record', (tester) async {
    await pumpScreen(
      tester,
      const ClaimSuccessSummary(
        groupTitle: 'Sesi Sore Klub Rajawali',
        totalScore: 487,
        arrowsShot: 60,
        avgPerArrow: 8.1,
        isPersonalBest: true,
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Personal Best Pertamamu!'), findsOneWidget);
    expect(find.text('487'), findsOneWidget); // the total stat tile
    expect(find.text('Lihat Papan Sesi'), findsOneWidget);
    expect(find.textContaining('Sesi Sore Klub Rajawali'), findsOneWidget);
  });

  testWidgets('a non-PB session still invites more training', (tester) async {
    await pumpScreen(
      tester,
      const ClaimSuccessSummary(
        groupTitle: 'Latihan Pagi',
        totalScore: 27,
        arrowsShot: 3,
        avgPerArrow: 9.0,
        isPersonalBest: false,
      ),
    );
    await tester.pump();

    expect(find.text('Personal Best Pertamamu!'), findsNothing);
    expect(find.text('27'), findsOneWidget);
    expect(find.textContaining('Rata-ratamu'), findsOneWidget);
  });

  testWidgets('an empty claim degrades to a plain warm welcome',
      (tester) async {
    await pumpScreen(tester, const ClaimSuccessSummary());
    await tester.pump();

    expect(find.text('Personal Best Pertamamu!'), findsNothing);
    expect(find.text('Skor ini kini milikmu'), findsOneWidget);
    expect(
      find.textContaining('Latihan pertamamu tercatat'),
      findsOneWidget,
    );
  });
}
