class ErrorFormatter {
  /// Maps any dynamic error/exception to a user-friendly corporate Indonesian message.
  static String getFriendlyMessage(dynamic error) {
    if (error == null) {
      return 'Terjadi kendala yang tidak terduga. Silakan coba beberapa saat lagi.';
    }

    final rawMessage = error.toString();
    final lowerMessage = rawMessage.toLowerCase();

    // 1. Google / Authentication specific errors
    if (lowerMessage.contains('apiexception: 10') || lowerMessage.contains('apiexception: 12501')) {
      return 'Masuk dibatalkan. Mohon pastikan layanan Google Play Services terkonfigurasi dengan benar di perangkat Anda.';
    }
    if (lowerMessage.contains('apiexception: 7') || 
        lowerMessage.contains('socketexception') || 
        lowerMessage.contains('network') || 
        lowerMessage.contains('connection') || 
        lowerMessage.contains('timed out') || 
        lowerMessage.contains('timeout')) {
      return 'Koneksi internet Anda terputus atau tidak stabil. Silakan periksa jaringan internet Anda dan coba lagi.';
    }
    if (lowerMessage.contains('apiexception: 8')) {
      return 'Terjadi kendala internal pada Google Play Services. Silakan mulai ulang aplikasi atau coba beberapa saat lagi.';
    }
    if (lowerMessage.contains('google') || lowerMessage.contains('id token')) {
      return 'Gagal memproses autentikasi Google. Silakan pastikan akun Google Anda aktif dan coba kembali.';
    }

    // 2. Biometric errors
    if (lowerMessage.contains('biometric') || lowerMessage.contains('fingerprint') || lowerMessage.contains('face id') || lowerMessage.contains('faceid')) {
      return 'Verifikasi biometrik tidak berhasil. Silakan coba kembali atau masuk menggunakan akun Google.';
    }

    // 3. HTTP / Network specific status codes/messages
    if (lowerMessage.contains('500') || lowerMessage.contains('server error') || lowerMessage.contains('internal server error')) {
      return 'Layanan kami sedang mengalami kendala teknis. Kami sedang berupaya memperbaikinya, mohon coba kembali beberapa saat lagi.';
    }
    if (lowerMessage.contains('401') || lowerMessage.contains('unauthorized') || lowerMessage.contains('tidak valid')) {
      if (lowerMessage.contains('login') || lowerMessage.contains('auth') || lowerMessage.contains('social')) {
        return 'Gagal melakukan autentikasi masuk. Silakan pastikan akun Google Anda aktif dan coba lagi.';
      }
      return 'Sesi masuk Anda tidak valid atau telah berakhir. Silakan masuk kembali.';
    }
    if (lowerMessage.contains('403') || lowerMessage.contains('forbidden')) {
      return 'Anda tidak memiliki akses untuk melakukan tindakan ini.';
    }
    if (lowerMessage.contains('404') || lowerMessage.contains('not found')) {
      return 'Data atau layanan yang diminta tidak ditemukan.';
    }
    if (lowerMessage.contains('422') || lowerMessage.contains('validation')) {
      return 'Data yang Anda masukkan kurang lengkap atau tidak sesuai ketentuan. Mohon periksa kembali.';
    }

    // 4. Default clean corporate message
    return 'Mohon maaf, terjadi kendala saat memproses permintaan Anda. Silakan hubungi dukungan atau coba lagi nanti.';
  }
}
