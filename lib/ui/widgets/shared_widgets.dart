part of '../../main.dart';

// --- Cupertino-style section header ---
class _SectionHeader extends StatelessWidget {
  final String text;
  final String? actionText;
  final VoidCallback? onAction;

  const _SectionHeader(this.text, {this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: DentistColors.secondaryText,
              letterSpacing: -0.08,
            ),
          ),
          const Spacer(),
          if (actionText != null)
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: onAction,
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DentistColors.turquoise,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// --- iOS-style inset grouped card container ---
class _CupertinoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _CupertinoCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DentistColors.cardFill,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: DentistColors.primary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// --- Round avatar with network image fallback ---
class _AvatarCircle extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const _AvatarCircle({
    required this.name,
    this.imageUrl,
    this.size = 52,
  });

  String get _initials {
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    final first = parts.isNotEmpty ? parts.first : '';
    final second = parts.length > 1 ? parts[1] : '';
    return (first.isNotEmpty ? first[0] : '') +
        (second.isNotEmpty ? second[0] : '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DentistColors.turquoise.withValues(alpha: 0.2),
            DentistColors.skyBlue.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.27),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text(
                  _initials,
                  style: TextStyle(
                    fontSize: size * 0.34,
                    fontWeight: FontWeight.w700,
                    color: DentistColors.primary,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                _initials,
                style: TextStyle(
                  fontSize: size * 0.34,
                  fontWeight: FontWeight.w700,
                  color: DentistColors.primary,
                ),
              ),
            ),
    );
  }
}

// --- News article card ---
class _NewsCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String title;
  final String summary;
  final String date;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback? onTap;

  const _NewsCard({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.summary,
    required this.date,
    this.icon = CupertinoIcons.doc_text,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: _CupertinoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: DentistColors.background,
                      child: Icon(icon, color: DentistColors.tertiaryText, size: 28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tagColor,
                    letterSpacing: -0.08,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: DentistColors.tertiaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: DentistColors.primaryText,
              letterSpacing: -0.41,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              color: DentistColors.secondaryText,
              letterSpacing: -0.24,
              height: 1.4,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// --- Featured news with gradient or API image ---
class _FeaturedNewsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final String? imageUrl;
  final VoidCallback? onTap;

  const _FeaturedNewsCard({
    required this.title,
    required this.subtitle,
    this.icon = CupertinoIcons.sparkles,
    this.gradientColors = const [DentistColors.primary, DentistColors.turquoise],
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: 260,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: hasImage
              ? null
              : LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            if (hasImage)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF000000).withValues(alpha: 0.1),
                      const Color(0xFF000000).withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: DentistColors.white.withValues(alpha: 0.85),
                    size: 22,
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: DentistColors.white,
                      letterSpacing: -0.41,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: DentistColors.white.withValues(alpha: 0.9),
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Doctor mini card for home tab ---
class _DoctorMiniCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const _DoctorMiniCard({
    required this.name,
    required this.specialty,
    required this.rating,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: DentistColors.cardFill,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: DentistColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _AvatarCircle(name: name, imageUrl: avatarUrl, size: 52),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: DentistColors.primaryText,
                letterSpacing: -0.24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              specialty,
              style: const TextStyle(
                fontSize: 13,
                color: DentistColors.secondaryText,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.star_fill, color: Color(0xFFE8B931), size: 13),
                const SizedBox(width: 3),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DentistColors.primaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Coming soon placeholder ---
class _ComingSoonPlaceholder extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _ComingSoonPlaceholder({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DentistColors.turquoise.withValues(alpha: 0.15),
                    DentistColors.skyBlue.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                size: 34,
                color: DentistColors.turquoise,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: DentistColors.primaryText,
                letterSpacing: -0.41,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: DentistColors.secondaryText,
                letterSpacing: -0.24,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
