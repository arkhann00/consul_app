part of '../main.dart';

class MainTabsPage extends StatelessWidget {
  const MainTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: const Color(0xE6F5F0EB),
        border: Border(
          top: BorderSide(
            color: DentistColors.separator.withValues(alpha: 0.4),
            width: 0.33,
          ),
        ),
        activeColor: DentistColors.primary,
        inactiveColor: DentistColors.tertiaryText,
        iconSize: 24,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news),
            activeIcon: Icon(CupertinoIcons.news_solid),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            activeIcon: Icon(CupertinoIcons.person_2_fill),
            label: 'Врачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_fill),
            label: 'Услуги',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            activeIcon: Icon(CupertinoIcons.calendar),
            label: 'Запись',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: 'Профиль',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return const HomeTab();
              case 1:
                return const DoctorsTab();
              case 2:
                return const ServicesTab();
              case 3:
                return const AppointmentsTab();
              case 4:
                return const ProfileTab();
              default:
                return const HomeTab();
            }
          },
        );
      },
    );
  }
}
