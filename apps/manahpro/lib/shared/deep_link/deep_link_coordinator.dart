import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:features_shared/features_shared.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/group_scoring/domain/join_link.dart';
import '../../features/group_scoring/presentation/group_scoring_providers.dart';
import '../../features/group_scoring/presentation/group_scoring_routes.dart';
import '../../router/app_router.dart';

part 'deep_link_coordinator.g.dart';

/// Captures Latihan Bersama invite deep links and funnels them to the join
/// preview (Sprint 09, tasks 9.1 & 9.4).
///
/// Three transports converge here:
/// * HTTPS App Links / Universal Links (`https://<host>/j/<code>`),
/// * the `manahpro://join?code=` custom-scheme fallback,
/// * the clipboard deferred stash a freshly-installed app left behind.
///
/// Routing is **auth-gated**: a signed-out user's link is stashed and resumed
/// only after they register / log in, so they never land on a preview whose API
/// calls would 401. Warm links for a signed-in user open immediately.
@Riverpod(keepAlive: true)
class DeepLinkCoordinator extends _$DeepLinkCoordinator {
  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;
  bool _clipboardChecked = false;

  @override
  Future<void> build() async {
    final appLinks = _appLinks ??= AppLinks();
    ref.onDispose(() => _sub?.cancel());

    // Warm links (app already running) arrive on the stream.
    _sub = appLinks.uriLinkStream.listen(_handleUri);

    // Cold-start link (the app was launched by tapping the link).
    final initial = await appLinks.getInitialLink();
    if (initial != null) {
      _handleUri(initial);
    } else {
      await _maybeResumeFromClipboard();
    }
  }

  void _handleUri(Uri uri) {
    final code = JoinLink.parseCode(uri.toString());
    if (code != null) _routeToCode(code);
  }

  void _routeToCode(String code) {
    if (ref.read(authProvider) is AuthAuthenticated) {
      _navigate(code);
    } else {
      // Stash and let the auth flow take over; resumed by [consumePending].
      ref.read(pendingJoinStoreProvider).save(code);
    }
  }

  /// Called from the app root when auth becomes authenticated: resume a stashed
  /// invite, or fall back to the clipboard deferred stash if there is none.
  Future<void> consumePending() async {
    if (ref.read(authProvider) is! AuthAuthenticated) return;
    final store = ref.read(pendingJoinStoreProvider);
    final code = await store.read();
    if (code != null) {
      await store.clear();
      _navigate(code);
      return;
    }
    await _maybeResumeFromClipboard();
  }

  /// Deferred deep link best-effort: read the join code the web landing page
  /// stashed on the clipboard and resume to the session. Only the explicit
  /// `manahpro:join:` stash is honored — never arbitrary clipboard text.
  Future<void> _maybeResumeFromClipboard() async {
    if (_clipboardChecked) return;
    if (ref.read(authProvider) is! AuthAuthenticated) return;
    _clipboardChecked = true;

    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trimLeft();
    if (text == null ||
        !text.toLowerCase().startsWith(JoinLink.clipboardPrefix)) {
      return;
    }
    final code = JoinLink.parseCode(text);
    if (code != null) _navigate(code);
  }

  /// Push the preview after the current frame so we never navigate during a
  /// router redirect / build phase.
  void _navigate(String code) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appRouter.push(GroupScoringRoutes.joinPreview(code));
    });
  }
}
