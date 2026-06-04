import 'package:go_router/go_router.dart';
import 'screens/paywall_screen.dart';
import 'screens/club_billing_screen.dart';

abstract final class MonetizationRoutes {
  static const String paywall = '/monetization/paywall';
  
  static String clubBilling(String clubId) => '/monetization/club-billing/$clubId';
}

final List<RouteBase> monetizationRoutes = [
  GoRoute(
    path: MonetizationRoutes.paywall,
    builder: (context, state) => const PaywallScreen(),
  ),
  GoRoute(
    path: '/monetization/club-billing/:id',
    builder: (context, state) {
      final clubId = state.pathParameters['id']!;
      final extra = state.extra as Map<String, dynamic>?;
      final clubName = extra?['clubName'] as String? ?? 'Klub';
      return ClubBillingScreen(
        clubId: clubId,
        clubName: clubName,
      );
    },
  ),
];
