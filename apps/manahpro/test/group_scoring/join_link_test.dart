import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/features/group_scoring/domain/join_link.dart';

/// Sprint 09 — link-first distribution helpers. Pure logic, so it is the part of
/// the deep-link feature we can fully pin down with unit tests: building the
/// WhatsApp-able link and parsing every entry point (link / QR / clipboard /
/// typed code) back to a single normalized join code.
void main() {
  const webBase = 'https://circlepro.web.id';

  group('webBaseFrom', () {
    test('strips the /api/ suffix and trailing slashes', () {
      expect(
        JoinLink.webBaseFrom('https://circlepro.web.id/api/'),
        'https://circlepro.web.id',
      );
      expect(
        JoinLink.webBaseFrom('https://circlepro.web.id/api'),
        'https://circlepro.web.id',
      );
      expect(
        JoinLink.webBaseFrom('https://circlepro.web.id/'),
        'https://circlepro.web.id',
      );
    });
  });

  group('buildShareUrl / buildSchemeUrl', () {
    test('builds an uppercased HTTPS invite link', () {
      expect(
        JoinLink.buildShareUrl('abc234', webBase: webBase),
        'https://circlepro.web.id/j/ABC234',
      );
    });

    test('builds the custom-scheme fallback', () {
      expect(JoinLink.buildSchemeUrl('abc234'), 'manahpro://join?code=ABC234');
    });
  });

  group('shareMessage', () {
    test('is link-first with the typed code as a fallback', () {
      final msg = JoinLink.shareMessage(
        code: 'abc234',
        title: 'Latihan Sore',
        webBase: webBase,
      );
      expect(msg, contains('Latihan Sore'));
      expect(msg, contains('https://circlepro.web.id/j/ABC234'));
      expect(msg, contains('ABC234'));
    });

    test('falls back to a default title', () {
      final msg = JoinLink.shareMessage(code: 'abc234', webBase: webBase);
      expect(msg, contains('Latihan Bersama'));
    });
  });

  group('parseCode', () {
    test('accepts a bare code and normalizes case', () {
      expect(JoinLink.parseCode('abc234'), 'ABC234');
      expect(JoinLink.parseCode('  ABC234 '), 'ABC234');
    });

    test('extracts from the HTTPS /j/<code> short link', () {
      expect(
        JoinLink.parseCode('https://circlepro.web.id/j/ABC234'),
        'ABC234',
      );
      expect(
        JoinLink.parseCode('https://circlepro.web.id/j/abc234'),
        'ABC234',
      );
    });

    test('extracts from the ?code= query link', () {
      expect(
        JoinLink.parseCode(
          'https://circlepro.web.id/group-scoring/join?code=abc234',
        ),
        'ABC234',
      );
    });

    test('extracts from the custom scheme', () {
      expect(
        JoinLink.parseCode('manahpro://join?code=abc234'),
        'ABC234',
      );
    });

    test('extracts from the clipboard deferred stash', () {
      expect(JoinLink.parseCode('manahpro:join:ABC234'), 'ABC234');
      expect(JoinLink.parseCode('manahpro:join:abc234'), 'ABC234');
    });

    test('does not mistake the literal "join" path segment for a code', () {
      expect(
        JoinLink.parseCode('https://circlepro.web.id/group-scoring/join'),
        isNull,
      );
    });

    test('returns null for empty, null or invalid input', () {
      expect(JoinLink.parseCode(null), isNull);
      expect(JoinLink.parseCode(''), isNull);
      expect(JoinLink.parseCode('   '), isNull);
      expect(JoinLink.parseCode('!@#'), isNull);
      expect(JoinLink.parseCode('https://circlepro.web.id/articles/foo'), isNull);
    });
  });
}
