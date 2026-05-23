part of '../main.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final int newsId;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final _repo = ConsulRepository.shared();
  late Future<NewsModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchNewsById(widget.newsId);
  }

  void _retry() {
    setState(() {
      _future = _repo.fetchNewsById(widget.newsId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Новость'),
        backgroundColor: const Color(0xE6F5F0EB),
        border: null,
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<NewsModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasError) {
              return _DetailError(
                message: '${snapshot.error}',
                onRetry: _retry,
              );
            }
            final n = snapshot.data!;
            final imageUrl = _repo.resolveMediaUrl(n.image);
            final hasImage = imageUrl.isNotEmpty;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: DentistColors.cardFill,
                          child: const Icon(
                            CupertinoIcons.photo,
                            size: 48,
                            color: DentistColors.tertiaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (hasImage) const SizedBox(height: 16),
                Text(
                  n.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: DentistColors.primaryText,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatRuShortDate(n.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: DentistColors.tertiaryText,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  n.description.trim(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: DentistColors.primaryText,
                    height: 1.5,
                    letterSpacing: -0.24,
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

class _DetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DetailError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Не удалось загрузить',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: DentistColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: DentistColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
