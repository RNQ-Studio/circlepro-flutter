abstract final class InputValidators {
  static String? required(String? value, {String? label}) {
    if (value == null || value.trim().isEmpty) {
      return '${label ?? 'Field'} tidak boleh kosong';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final isValid = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(value);
    return isValid ? null : 'Format email tidak valid';
  }

  static String? minLength(String? value, int min, {String? label}) {
    if (value == null || value.length < min) {
      return '${label ?? 'Field'} minimal $min karakter';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }
}
