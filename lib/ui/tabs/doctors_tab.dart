part of '../../main.dart';

class DoctorsTab extends StatefulWidget {
  const DoctorsTab({super.key});

  @override
  State<DoctorsTab> createState() => _DoctorsTabState();
}

class _DoctorsTabState extends State<DoctorsTab> {
  final _repo = ConsulRepository.shared();
  late Future<List<DoctorModel>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchDoctors();
  }

  void _retry() {
    setState(() {
      _future = _repo.fetchDoctors();
    });
  }

  void _openDoctor(BuildContext context, int id) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => DoctorDetailScreen(doctorId: id),
      ),
    );
  }

  List<DoctorModel> _filter(List<DoctorModel> all) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((d) {
      final hay =
          '${d.firstName} ${d.lastName} ${d.patronymic ?? ''} ${d.position} ${d.description ?? ''}'
              .toLowerCase();
      return hay.contains(q);
    }).toList();
  }

  static String _experienceSnippet(String? description) {
    if (description == null || description.isEmpty) return '';
    final line = description.split(RegExp(r'\r?\n')).first.trim();
    if (line.length > 48) return '${line.substring(0, 48).trim()}…';
    return line;
  }

  static _Doctor _toUiDoctor(DoctorModel m, ConsulRepository repo) {
    final url = repo.resolveMediaUrl(m.avatarUrl);
    final avatar = url.isEmpty ? null : url;
    return _Doctor(
      name: m.displayName,
      specialty: m.position,
      rating: 4.8,
      experience: _experienceSnippet(m.description),
      avatarUrl: avatar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Врачи'),
            backgroundColor: Color(0xE6F5F0EB),
            border: null,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              child: FutureBuilder<List<DoctorModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                      height: 280,
                      child: Center(child: CupertinoActivityIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return _DoctorsLoadError(
                      message: '${snapshot.error}',
                      onRetry: _retry,
                    );
                  }
                  final all = snapshot.data!;
                  final filtered = _filter(all);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoSearchTextField(
                        placeholder: 'Поиск врача',
                        backgroundColor: DentistColors.cardFill,
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        style: const TextStyle(
                          color: DentistColors.primaryText,
                          fontSize: 16,
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      const SizedBox(height: 20),
                      const _SectionHeader('Наши специалисты'),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            'Никого не нашли — попробуйте другой запрос.',
                            style: TextStyle(color: DentistColors.secondaryText, fontSize: 15),
                          ),
                        )
                      else
                        for (final m in filtered) ...[
                          _DoctorCard(
                            doctor: _toUiDoctor(m, _repo),
                            onTap: () => _openDoctor(context, m.id),
                          ),
                          const SizedBox(height: 10),
                        ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorsLoadError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DoctorsLoadError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        color: DentistColors.cardFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Не удалось загрузить врачей',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: DentistColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: DentistColors.secondaryText),
          ),
          const SizedBox(height: 12),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onPressed: onRetry,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}

class _Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String experience;
  final String? avatarUrl;

  const _Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    this.avatarUrl,
  });
}

class _DoctorCard extends StatelessWidget {
  final _Doctor doctor;
  final VoidCallback onTap;

  const _DoctorCard({required this.doctor, required this.onTap});

  String _initials(String name) {
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    final first = parts.isNotEmpty ? parts.first : '';
    final second = parts.length > 1 ? parts[1] : '';
    return (first.isNotEmpty ? first[0] : '') +
        (second.isNotEmpty ? second[0] : '');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: _CupertinoCard(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DentistColors.turquoise.withValues(alpha: 0.2),
                    DentistColors.skyBlue.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty
                  ? Image.network(
                      doctor.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          _initials(doctor.name),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: DentistColors.primary,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        _initials(doctor.name),
                        style: const TextStyle(
                          fontSize: 18,
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
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: DentistColors.primaryText,
                      letterSpacing: -0.32,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 14,
                      color: DentistColors.secondaryText,
                      letterSpacing: -0.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.star_fill,
                        color: Color(0xFFE8B931),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: DentistColors.primaryText,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          doctor.experience.isEmpty ? 'Стаж — уточняется' : doctor.experience,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: DentistColors.tertiaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: DentistColors.tertiaryText,
            ),
          ],
        ),
      ),
    );
  }
}
