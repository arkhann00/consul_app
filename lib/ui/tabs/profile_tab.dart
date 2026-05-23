part of '../../main.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _repo = ConsulRepository.shared();
  late Future<AppUser?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _repo.fetchCurrentProfile();
  }

  void _reloadProfile() {
    setState(() {
      _profileFuture = _repo.fetchCurrentProfile();
    });
  }

  Future<void> _signOut() async {
    await _repo.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Профиль'),
        backgroundColor: Color(0xE6F5F0EB),
        border: null,
      ),
      child: SafeArea(
        child: FutureBuilder<AppUser?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: DentistColors.secondaryText),
                      ),
                      const SizedBox(height: 12),
                      CupertinoButton.filled(
                        onPressed: _reloadProfile,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final row = snapshot.data;
            final name = row?.displayName ?? 'Пользователь';
            final phone = row?.phone ?? '';
            final isAdmin = row?.isAdmin ?? false;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              children: [
                const SizedBox(height: 12),
                _CupertinoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  DentistColors.turquoise.withValues(alpha: 0.25),
                                  DentistColors.skyBlue.withValues(alpha: 0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: DentistColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: DentistColors.primaryText,
                                  ),
                                ),
                                if (phone.isNotEmpty)
                                  Text(
                                    phone,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: DentistColors.secondaryText,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isAdmin) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: DentistColors.turquoise.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Администратор',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DentistColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: _reloadProfile,
                  child: const Text('Обновить профиль'),
                ),
                const SizedBox(height: 12),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  color: DentistColors.cardFill,
                  onPressed: _signOut,
                  child: const Text(
                    'Выйти',
                    style: TextStyle(
                      color: Color(0xFFC0392B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Консилиум · v1.0.0',
                    style: TextStyle(
                      fontSize: 13,
                      color: DentistColors.tertiaryText.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
