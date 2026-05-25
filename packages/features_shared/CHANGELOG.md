## [Unreleased]

### Changed
- Migrated all state providers (Auth, Profile, Notifications, Settings) to Riverpod Generator (`@riverpod` and `@Riverpod(keepAlive: true)`).
- Re-architected providers naming conventions (`authNotifierProvider` -> `authProvider`, etc.) to match generator standards.

## 0.0.1

- Initial release of shared feature modules.
- Added starter auth implementation, profile and notifications stubs, and shared settings logic for theme and locale preferences.
