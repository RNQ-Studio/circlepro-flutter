import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Layar utama fitur {{feature_name.titleCase()}}
class {{feature_name.pascalCase()}}Screen extends ConsumerWidget {
  const {{feature_name.pascalCase()}}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch notifier provider
    // final state = ref.watch({{feature_name.camelCase()}}Provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('{{feature_name.titleCase()}}'),
      ),
      body: const Center(
        child: Text('{{feature_name.titleCase()}} — belum diimplementasi'),
      ),
    );
  }
}
