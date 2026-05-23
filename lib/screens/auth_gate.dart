part of '../main.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _repo = ConsulRepository.shared();

  @override
  void initState() {
    super.initState();
    _repo.isAuthenticated.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _repo.isAuthenticated.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_repo.isAuthenticated.value) {
      return const MainTabsPage();
    }
    return const AuthScreen();
  }
}
