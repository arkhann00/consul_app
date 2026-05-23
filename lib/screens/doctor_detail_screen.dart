part of '../main.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({super.key, required this.doctorId});

  final int doctorId;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final _repo = ConsulRepository.shared();
  late Future<DoctorModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchDoctorById(widget.doctorId);
  }

  void _retry() {
    setState(() {
      _future = _repo.fetchDoctorById(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Врач'),
        backgroundColor: const Color(0xE6F5F0EB),
        border: null,
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<DoctorModel>(
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
            final d = snapshot.data!;
            final avatarUrl = _repo.resolveMediaUrl(d.avatarUrl);
            final avatar = avatarUrl.isEmpty ? null : avatarUrl;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Center(
                  child: _AvatarCircle(
                    name: d.displayName,
                    imageUrl: avatar,
                    size: 120,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  d.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: DentistColors.primaryText,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  d.position,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: DentistColors.secondaryText,
                  ),
                ),
                if (d.description != null && d.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'О враче',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: DentistColors.secondaryText,
                      letterSpacing: -0.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _CupertinoCard(
                    child: Text(
                      d.description!.trim(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: DentistColors.primaryText,
                        height: 1.45,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
