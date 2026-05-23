part of '../../main.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _repo = ConsulRepository.shared();
  late Future<HomeFeed> _feed;

  static const _featuredGradients = [
    [DentistColors.primary, DentistColors.turquoise],
    [DentistColors.turquoise, DentistColors.skyBlue],
    [Color(0xFF5B7E8A), DentistColors.primary],
  ];

  static const _featuredIcons = [
    CupertinoIcons.tag_fill,
    CupertinoIcons.gift_fill,
    CupertinoIcons.sparkles,
  ];

  static const _tagStyles = [
    (tag: 'Событие', color: DentistColors.turquoise),
    (tag: 'Здоровье', color: DentistColors.primary),
    (tag: 'Технологии', color: Color(0xFF5B7E8A)),
    (tag: 'Акция', color: Color(0xFFE8B931)),
  ];

  static const _newsIcons = [
    CupertinoIcons.star_fill,
    CupertinoIcons.heart_fill,
    CupertinoIcons.sparkles,
    CupertinoIcons.tag_fill,
  ];

  @override
  void initState() {
    super.initState();
    _feed = _repo.fetchHomeFeed();
  }

  void _retry() {
    setState(() {
      _feed = _repo.fetchHomeFeed();
    });
  }

  void _openDoctor(BuildContext context, int id) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => DoctorDetailScreen(doctorId: id),
      ),
    );
  }

  void _openNews(BuildContext context, int id) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => NewsDetailScreen(newsId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Консилиум'),
            backgroundColor: DentistColors.background.withValues(alpha: 0.92),
            border: null,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () {},
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: DentistColors.cardFill,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: DentistColors.primary.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.bell,
                  size: 18,
                  color: DentistColors.primaryText,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Семейная стоматология',
                    style: TextStyle(
                      fontSize: 15,
                      color: DentistColors.secondaryText,
                      letterSpacing: -0.24,
                    ),
                  ),
                  const SizedBox(height: 18),
                  FutureBuilder<HomeFeed>(
                    future: _feed,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox(
                          height: 220,
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return _HomeLoadError(
                          message: '${snapshot.error}',
                          onRetry: _retry,
                        );
                      }
                      final feed = snapshot.data!;
                      return _buildFeedBody(feed);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedBody(HomeFeed feed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeaturedStrip(feed.news),
        const SizedBox(height: 28),
        const _SectionHeader('Наши врачи', actionText: 'Все'),
        _buildDoctorStrip(feed.doctors),
        const SizedBox(height: 28),
        const _SectionHeader('Новости клиники'),
        _buildNewsList(feed.news),
      ],
    );
  }

  Widget _buildFeaturedStrip(List<NewsModel> news) {
    if (news.isEmpty) {
      return const SizedBox(
        height: 140,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Новости скоро появятся',
            style: TextStyle(color: DentistColors.secondaryText, fontSize: 15),
          ),
        ),
      );
    }
    final featured = news.take(3).toList();
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: featured.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final n = featured[i];
          final g = _featuredGradients[i % _featuredGradients.length];
          final ic = _featuredIcons[i % _featuredIcons.length];
          final img = _repo.resolveMediaUrl(n.image);
          return _FeaturedNewsCard(
            title: n.title,
            subtitle: n.featuredSubtitle,
            icon: ic,
            gradientColors: g,
            imageUrl: img.isEmpty ? null : img,
            onTap: () => _openNews(context, n.id),
          );
        },
      ),
    );
  }

  Widget _buildDoctorStrip(List<DoctorModel> doctors) {
    if (doctors.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Список врачей обновляется',
            style: TextStyle(color: DentistColors.secondaryText, fontSize: 15),
          ),
        ),
      );
    }
    return SizedBox(
      height: 185,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: doctors.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final d = doctors[i];
          final avatarUrl = _repo.resolveMediaUrl(d.avatarUrl);
          final avatar = avatarUrl.isEmpty ? null : avatarUrl;
          return _DoctorMiniCard(
            name: d.displayName,
            specialty: d.position,
            rating: 4.8,
            avatarUrl: avatar,
            onTap: () => _openDoctor(context, d.id),
          );
        },
      ),
    );
  }

  Widget _buildNewsList(List<NewsModel> news) {
    if (news.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Пока нет новостей',
          style: TextStyle(color: DentistColors.secondaryText, fontSize: 15),
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < news.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final item = news[i];
              final img = _repo.resolveMediaUrl(item.image);
              return _NewsCard(
                tag: _tagStyles[i % _tagStyles.length].tag,
                tagColor: _tagStyles[i % _tagStyles.length].color,
                title: item.title,
                summary: item.summaryExcerpt,
                date: formatRuShortDate(item.createdAt),
                icon: _newsIcons[i % _newsIcons.length],
                imageUrl: img.isEmpty ? null : img,
                onTap: () => _openNews(context, item.id),
              );
            },
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _HomeLoadError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeLoadError({required this.message, required this.onRetry});

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
            'Не удалось загрузить данные',
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
