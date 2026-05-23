import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/api/api_exception.dart';
import 'core/config/api_config.dart';
import 'data/consul_repository.dart';
import 'util/ru_date.dart';

part 'app/dentist_colors.dart';
part 'app/my_app.dart';
part 'screens/main_tabs_page.dart';
part 'screens/auth_gate.dart';
part 'screens/auth_screen.dart';
part 'screens/doctor_detail_screen.dart';
part 'screens/news_detail_screen.dart';
part 'ui/widgets/shared_widgets.dart';
part 'ui/tabs/home_tab.dart';
part 'ui/tabs/appointments_tab.dart';
part 'ui/tabs/services_tab.dart';
part 'ui/tabs/doctors_tab.dart';
part 'ui/tabs/profile_tab.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/app.env');
  final baseUrl = dotenv.env['API_BASE_URL']?.trim() ?? '';

  if (baseUrl.isEmpty) {
    runApp(const ConfigMissingApp());
    return;
  }

  ApiConfig.init(base: baseUrl);
  await ConsulRepository.shared().bootstrap();
  runApp(const MyApp());
}
