import 'package:core/core.dart';
import 'package:core/src/utils/error_formatter.dart';
import 'package:flutter_test/flutter_test.dart' hide ErrorFormatter;

class TestAppConfig extends AppConfig {
  TestAppConfig(this.environment);

  @override
  final Environment environment;

  @override
  String get baseUrl => 'https://example.com';
}

void main() {
  group('ErrorFormatter.getFriendlyMessage', () {
    test('handles null error', () {
      expect(
        ErrorFormatter.getFriendlyMessage(null),
        'Terjadi kendala yang tidak terduga. Silakan coba beberapa saat lagi.',
      );
    });

    test('handles ApiException 10/12501 (Google play cancels/errors)', () {
      expect(
        ErrorFormatter.getFriendlyMessage('ApiException: 10'),
        contains('Masuk dibatalkan'),
      );
      expect(
        ErrorFormatter.getFriendlyMessage('ApiException: 12501'),
        contains('Masuk dibatalkan'),
      );
    });

    test('handles network exceptions / timeouts', () {
      expect(
        ErrorFormatter.getFriendlyMessage('SocketException'),
        contains('Koneksi internet Anda terputus'),
      );
      expect(
        ErrorFormatter.getFriendlyMessage('timeout'),
        contains('Koneksi internet Anda terputus'),
      );
    });

    test('handles Google auth specific errors', () {
      expect(
        ErrorFormatter.getFriendlyMessage('Google sign in failed'),
        contains('Gagal memproses autentikasi Google'),
      );
    });

    test('handles 401/Unauthorized with isLogin = true', () {
      expect(
        ErrorFormatter.getFriendlyMessage('Unauthorized', isLogin: true),
        'Gagal melakukan autentikasi masuk. Silakan pastikan akun Google Anda aktif dan coba lagi.',
      );
      expect(
        ErrorFormatter.getFriendlyMessage('401 bad response', isLogin: true),
        'Gagal melakukan autentikasi masuk. Silakan pastikan akun Google Anda aktif dan coba lagi.',
      );
    });

    test('handles 401/Unauthorized with isLogin = false', () {
      expect(
        ErrorFormatter.getFriendlyMessage('Unauthorized', isLogin: false),
        'Sesi masuk Anda tidak valid atau telah berakhir. Silakan masuk kembali.',
      );
      expect(
        ErrorFormatter.getFriendlyMessage('401 bad response', isLogin: false),
        'Sesi masuk Anda tidak valid atau telah berakhir. Silakan masuk kembali.',
      );
    });

    test('handles 500 server errors', () {
      expect(
        ErrorFormatter.getFriendlyMessage('500 Internal Server Error'),
        contains('Layanan kami sedang mengalami kendala teknis'),
      );
    });

    test('handles fallback/generic errors', () {
      expect(
        ErrorFormatter.getFriendlyMessage('some random error'),
        'Mohon maaf, terjadi kendala saat memproses permintaan Anda. Silakan hubungi dukungan atau coba lagi nanti.',
      );
    });

    test('appends raw error message when AppConfig.instance.environment == Environment.dev', () {
      AppConfig.instance = TestAppConfig(Environment.dev);
      expect(
        ErrorFormatter.getFriendlyMessage('ApiException: 10'),
        contains('[DEBUG ERROR: ApiException: 10]'),
      );
    });

    test('does NOT append raw error message when AppConfig.instance.environment == Environment.prod', () {
      AppConfig.instance = TestAppConfig(Environment.prod);
      expect(
        ErrorFormatter.getFriendlyMessage('ApiException: 10'),
        isNot(contains('[DEBUG ERROR:')),
      );
    });
  });
}
