// lib/features/ui_gallery/data/dummy_data.dart

abstract final class DummyData {
  static const List<String> names = [
    'Ahmad Rizki', 'Budi Santoso', 'Citra Dewi', 'Dian Pratama',
    'Eka Wulandari', 'Faisal Hasan', 'Gita Rahayu', 'Hendra Wijaya',
    'Intan Permata', 'Joko Susilo', 'Kartika Sari', 'Lukman Hakim',
    'Maya Indah', 'Nanda Putra', 'Okta Kurnia',
  ];

  static const List<String> roles = [
    'Flutter Developer', 'Backend Engineer', 'UI/UX Designer',
    'Product Manager', 'DevOps Engineer', 'Mobile Developer',
    'Frontend Developer', 'Data Scientist', 'QA Engineer', 'Tech Lead',
    'Scrum Master', 'Business Analyst', 'System Architect',
    'Security Engineer', 'Cloud Engineer',
  ];

  static const List<String> techStacks = [
    'Flutter', 'Laravel', 'Next.js', 'React Native', 'Vue.js',
    'Node.js', 'Django', 'Spring Boot', 'FastAPI', 'NestJS',
  ];

  static const List<String> faqs = [
    'Apa itu Flutter?',
    'Bagaimana cara instalasi Flutter?',
    'Apa perbedaan StatelessWidget dan StatefulWidget?',
    'Bagaimana cara menggunakan Riverpod?',
    'Apa itu GoRouter dan cara menggunakannya?',
  ];

  static const List<String> faqAnswers = [
    'Flutter adalah framework open-source dari Google untuk membuat aplikasi cross-platform dari satu codebase Dart.',
    'Download Flutter SDK dari flutter.dev, ekstrak ke folder pilihan, lalu tambahkan flutter/bin ke PATH sistem Anda.',
    'StatelessWidget tidak memiliki state yang bisa berubah setelah build. StatefulWidget punya State yang bisa diperbarui dengan setState().',
    'Riverpod adalah library state management type-safe untuk Flutter. Definisikan Provider, lalu akses via ref.watch() atau ref.read().',
    'GoRouter adalah package deklaratif untuk routing Flutter, mendukung deep linking, redirect, dan named routes.',
  ];

  static const List<String> searchItems = [
    'Flutter Widget', 'Dart Async', 'State Management', 'Navigation Router',
    'Material Design', 'Riverpod Provider', 'Go Router', 'Animations',
    'Testing Widget', 'Platform Channel', 'Custom Painter', 'Gesture Detector',
    'Bloc Pattern', 'Provider Pattern', 'Flutter Hooks',
  ];

  static const List<String> comments = [
    'Kode ini sangat membantu! Terima kasih banyak.',
    'Penjelasannya sangat jelas dan mudah dipahami.',
    'Saya sudah mencoba dan berhasil. Top banget!',
  ];

  static const List<String> tokens = [
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
    'sk-proj-AbCdEfGhIjKlMnOpQrStUvWx',
    'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    'AKIAIOSFODNN7EXAMPLE',
  ];

  static const List<String> tokenLabels = [
    'JWT Token',
    'API Key',
    'GitHub Token',
    'AWS Access Key',
  ];
}
