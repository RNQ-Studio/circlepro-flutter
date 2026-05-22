extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');

  bool get isValidEmail =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(this);

  bool get isValidPhone => RegExp(r'^\+?[\d\s\-()]{8,}$').hasMatch(this);

  String? get nullIfEmpty => isEmpty ? null : this;
}

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String get orEmpty => this ?? '';
}
