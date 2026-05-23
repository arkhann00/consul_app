part of '../../main.dart';

class AppointmentsTab extends StatelessWidget {
  const AppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Запись'),
        backgroundColor: Color(0xE6F5F0EB),
        border: null,
      ),
      child: const SafeArea(
        child: _ComingSoonPlaceholder(
          title: 'Онлайн-запись',
          description: 'Скоро здесь можно будет записаться к врачу, выбрать удобное время и управлять визитами.',
          icon: CupertinoIcons.calendar,
        ),
      ),
    );
  }
}
