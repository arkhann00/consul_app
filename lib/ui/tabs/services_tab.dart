part of '../../main.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Услуги'),
        backgroundColor: Color(0xE6F5F0EB),
        border: null,
      ),
      child: const SafeArea(
        child: _ComingSoonPlaceholder(
          title: 'Каталог услуг',
          description: 'Полный список услуг с ценами и описаниями появится в ближайшем обновлении.',
          icon: CupertinoIcons.heart_fill,
        ),
      ),
    );
  }
}
