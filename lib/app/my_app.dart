part of '../main.dart';

/// Shown when [assets/app.env] has no `API_BASE_URL`.
class ConfigMissingApp extends StatelessWidget {
  const ConfigMissingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: DentistColors.primary,
        scaffoldBackgroundColor: DentistColors.background,
      ),
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Консилиум'),
          backgroundColor: Color(0xE6F5F0EB),
          border: null,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Нужен адрес API',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: DentistColors.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Откройте assets/app.env и укажите API_BASE_URL '
                  '(например http://127.0.0.1:8000 для локального бэкенда). '
                  'На Android-эмуляторе часто используют http://10.0.2.2:8000. '
                  'Перезапустите приложение.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: DentistColors.secondaryText.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Консилиум',
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: DentistColors.primary,
        primaryContrastingColor: DentistColors.white,
        scaffoldBackgroundColor: DentistColors.background,
        barBackgroundColor: Color(0xE6F5F0EB),
        textTheme: CupertinoTextThemeData(
          primaryColor: DentistColors.primary,
          textStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            color: DentistColors.primaryText,
            letterSpacing: -0.41,
          ),
          navTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: DentistColors.primaryText,
            letterSpacing: -0.41,
          ),
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: DentistColors.primaryText,
            letterSpacing: 0.41,
          ),
          tabLabelTextStyle: TextStyle(
            fontFamily: '.SF Pro Text',
            fontSize: 10,
            letterSpacing: -0.24,
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
