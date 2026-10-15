import 'package:flutter/material.dart';

import '../infrastructure/google_session_client.dart';
import 'design/zimba_brand.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

enum _AuthMode { signIn, register }

/// The only app entry point for an unsigned device. Financial setup deliberately
/// lives after authentication, in the optional account and card flows.
class ZimbaAuthPage extends StatefulWidget {
  const ZimbaAuthPage({
    required this.client,
    required this.isConfigured,
    required this.onAuthenticated,
    super.key,
  });

  final GoogleSessionClient client;
  final bool isConfigured;
  final ValueChanged<ApiSession> onAuthenticated;

  @override
  State<ZimbaAuthPage> createState() => _ZimbaAuthPageState();
}

class _ZimbaAuthPageState extends State<ZimbaAuthPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var mode = _AuthMode.signIn;
  var obscurePassword = true;
  var loading = false;
  String? error;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!widget.isConfigured) {
      setState(() => error = 'O acesso ainda não foi configurado neste app.');
      return;
    }
    if (!formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final session = switch (mode) {
        _AuthMode.signIn => await widget.client.signInWithPassword(
          email: emailController.text,
          password: passwordController.text,
        ),
        _AuthMode.register => await widget.client.registerWithPassword(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
        ),
      };
      if (mounted) widget.onAuthenticated(session);
    } on GoogleSessionException catch (exception) {
      if (!mounted) return;
      setState(() => error = _messageFor(exception));
    } catch (_) {
      if (!mounted) return;
      setState(() => error = 'Não foi possível continuar agora. Tente novamente.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void changeMode(_AuthMode nextMode) {
    setState(() {
      mode = nextMode;
      error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRegistration = mode == _AuthMode.register;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: ZimbaCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ZimbaLogo(size: ZimbaLogoSize.lg),
                        const SizedBox(height: 8),
                        Text(
                          'Finanças da sua família',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ZimbaColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _ModeSelector(mode: mode, onChanged: changeMode),
                        const SizedBox(height: 24),
                        Text(
                          isRegistration ? 'Comece sua família' : 'Bem-vindo de volta',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isRegistration
                              ? 'Você será o administrador de uma família isolada.'
                              : 'Entre para acompanhar e organizar as finanças.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ZimbaColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              if (isRegistration) ...[
                                TextFormField(
                                  controller: nameController,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.name],
                                  decoration: const InputDecoration(labelText: 'Seu nome'),
                                  validator: (value) => (value?.trim().isEmpty ?? true)
                                      ? 'Informe seu nome.'
                                      : null,
                                ),
                                const SizedBox(height: 14),
                              ],
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.username],
                                decoration: const InputDecoration(labelText: 'E-mail'),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  return email.contains('@') ? null : 'Informe um e-mail válido.';
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: [
                                  isRegistration
                                      ? AutofillHints.newPassword
                                      : AutofillHints.password,
                                ],
                                onFieldSubmitted: (_) => submit(),
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  helperText: isRegistration ? 'Use pelo menos 9 caracteres.' : null,
                                  suffixIcon: IconButton(
                                    tooltip: obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if ((value?.isEmpty ?? true)) return 'Informe a senha.';
                                  if (isRegistration && value!.length < 9) {
                                    return 'Use pelo menos 9 caracteres.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 16),
                          ZimbaFeedbackBanner(
                            icon: Icons.error_outline,
                            title: 'Não foi possível continuar',
                            body: error!,
                            tone: ZimbaTone.danger,
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: loading ? null : submit,
                            icon: Icon(isRegistration ? Icons.people_alt_outlined : Icons.login),
                            label: Text(loading
                                ? 'Aguarde…'
                                : isRegistration
                                    ? 'Criar família'
                                    : 'Entrar'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Seus dados financeiros ficam separados por família.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ZimbaColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.mode, required this.onChanged});
  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: ZimbaColors.surfaceMuted,
      borderRadius: BorderRadius.circular(ZimbaRadii.md),
    ),
    child: Row(
      children: [
        for (final item in _AuthMode.values)
          Expanded(
            child: TextButton(
              onPressed: () => onChanged(item),
              style: TextButton.styleFrom(
                backgroundColor: mode == item ? ZimbaColors.surface : Colors.transparent,
                foregroundColor: ZimbaColors.foreground,
              ),
              child: Text(item == _AuthMode.signIn ? 'Entrar' : 'Criar família'),
            ),
          ),
      ],
    ),
  );
}

String _messageFor(GoogleSessionException exception) {
  final message = exception.message;
  if (message.endsWith('_401')) return 'E-mail ou senha inválidos.';
  if (message.endsWith('_409')) return 'Este e-mail já está cadastrado.';
  if (message.endsWith('_400')) return 'Confira os dados informados.';
  return 'O serviço de acesso está indisponível. Tente novamente.';
}
