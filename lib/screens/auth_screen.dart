part of '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _repo = ConsulRepository.shared();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  int _segment = 0;
  bool _loading = false;
  bool _obscure = true;
  String? _errorText;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorText = null;
      _loading = true;
    });
    try {
      final phone = _phone.text.trim();
      final password = _password.text;

      if (phone.isEmpty || password.isEmpty) {
        setState(() => _errorText = 'Введите телефон и пароль');
        return;
      }
      if (password.length < 6) {
        setState(() => _errorText = 'Пароль не короче 6 символов');
        return;
      }

      if (_segment == 0) {
        await _repo.signInWithPhone(phone: phone, password: password);
      } else {
        final name = _name.text.trim();
        if (name.isEmpty) {
          setState(() => _errorText = 'Укажите имя');
          return;
        }
        await _repo.signUpWithPhone(
          name: name,
          phone: phone,
          password: password,
        );
      }
    } catch (e, st) {
      debugPrint('$e\n$st');
      if (mounted) {
        setState(() => _errorText = _humanAuthError(e));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _humanAuthError(Object e) {
    if (e is ApiException) {
      final msg = e.message;
      if (msg.contains('User with this phone already exists')) {
        return 'Этот телефон уже зарегистрирован';
      }
      if (msg.contains('Invalid phone or password')) {
        return 'Неверный телефон или пароль';
      }
      return msg;
    }
    return 'Ошибка: $e';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: DentistColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Консилиум'),
        backgroundColor: Color(0xE6F5F0EB),
        border: null,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
          children: [
            const SizedBox(height: 8),
            const Text(
              'Вход в аккаунт',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: DentistColors.primaryText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Вход по телефону и паролю. Запись и персональные данные — после регистрации.',
              style: TextStyle(
                fontSize: 15,
                color: DentistColors.secondaryText,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _segment,
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Вход'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Регистрация'),
                  ),
                },
                onValueChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _segment = v;
                    _errorText = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            if (_segment == 1) ...[
              _AuthField(
                controller: _name,
                placeholder: 'Имя и фамилия',
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
              ),
              const SizedBox(height: 10),
            ],
            _AuthField(
              controller: _phone,
              placeholder: 'Телефон',
              keyboardType: TextInputType.phone,
              autocorrect: false,
            ),
            const SizedBox(height: 10),
            _AuthField(
              controller: _password,
              placeholder: 'Пароль',
              obscureText: _obscure,
              suffix: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () => setState(() => _obscure = !_obscure),
                child: Icon(
                  _obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  size: 20,
                  color: DentistColors.secondaryText,
                ),
              ),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFC0392B),
                  height: 1.3,
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CupertinoActivityIndicator(color: DentistColors.white)
                    : Text(_segment == 0 ? 'Войти' : 'Зарегистрироваться'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final Widget? suffix;

  const _AuthField({
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return _CupertinoCard(
      padding: EdgeInsets.only(left: 16, right: suffix == null ? 16 : 8, top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField.borderless(
              controller: controller,
              placeholder: placeholder,
              keyboardType: keyboardType,
              obscureText: obscureText,
              textCapitalization: textCapitalization,
              autocorrect: autocorrect,
              padding: const EdgeInsets.symmetric(vertical: 12),
              style: const TextStyle(
                fontSize: 17,
                color: DentistColors.primaryText,
              ),
              placeholderStyle: const TextStyle(
                fontSize: 17,
                color: DentistColors.tertiaryText,
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
