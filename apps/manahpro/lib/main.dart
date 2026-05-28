import 'package:core/core.dart';

import 'bootstrap.dart';
import 'config/main_config.dart';

void main() async {
  AppConfig.instance = MainConfig();
  await bootstrap();
}
