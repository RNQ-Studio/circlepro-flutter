import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/scoring/domain/round_preset.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';

void main() {
  group('RoundPreset', () {
    test('ships official-style WA presets with sighter ends', () {
      final outdoor = RoundPreset.byKey('wa_70m_720');
      final indoor = RoundPreset.byKey('wa_18m_indoor');

      expect(outdoor, isNotNull);
      expect(outdoor!.distanceCategory, DistanceCategory.d70m);
      expect(outdoor.distanceM, 70);
      expect(outdoor.environment, ArcheryEnvironment.outdoor);
      expect(outdoor.numEnds, 12);
      expect(outdoor.arrowsPerEnd, 6);
      expect(outdoor.targetFaceCm, 122);
      expect(outdoor.sighterEndCount, 2);

      expect(indoor, isNotNull);
      expect(indoor!.distanceM, 18);
      expect(indoor.environment, ArcheryEnvironment.indoor);
      expect(indoor.numEnds, 20);
      expect(indoor.arrowsPerEnd, 3);
      expect(indoor.targetFaceCm, 40);
      expect(indoor.sighterEndCount, 2);
    });

    test('filters presets by category without hiding manual format', () {
      final wa = RoundPreset.byCategory(RoundPresetCategory.worldArchery);
      final latihan = RoundPreset.byCategory(RoundPresetCategory.latihanNasional);

      expect(wa.map((p) => p.key), contains('wa_70m_720'));
      expect(latihan.map((p) => p.key), contains('latihan_30m_36'));
      expect(RoundPreset.values, hasLength(greaterThanOrEqualTo(5)));
    });
  });
}
