import 'package:core/core.dart';

import 'bootstrap.dart';
import 'config/variant_config.dart';

void main() async {
  AppConfig.instance = VariantConfig();
  await bootstrap();
}
