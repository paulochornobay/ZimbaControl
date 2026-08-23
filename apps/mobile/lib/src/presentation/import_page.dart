import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../application/import_parser.dart';
import '../data/local/app_database.dart';
import 'dashboard_page.dart';
import 'design/instrument_display.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';
import 'registries_page.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({required this.database, super.key});

  final AppDatabase database;

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  Future<ImportBatchDetails?>? latestFuture;
  bool loading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    latestFuture = widget.database.getLatestImportBatchDetails();
  }

  Future<void> pickAndImport() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'ofx'],
        withData: true,
      );
      final file = result?.files.single;
      final bytes = file?.bytes;
      if (file == null || bytes == null) {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        return;
      }

      CsvImportMapping? mapping;
      if (file.extension?.toLowerCase() == 'csv') {
        final inspection = inspectCsvFile(fileName: file.name, bytes: bytes);
        if (!mounted) {
          return;
        }
        setState(() {
          loading = false;
        });
        mapping = await Navigator.of(context).push<CsvImportMapping>(
          MaterialPageRoute(
            builder: (context) =>
                CsvMappingPage(fileName: file.name, inspection: inspection),
          ),
        );
        if (mapping == null || !mounted) {
          return;
        }
        setState(() {
          loading = true;
        });
      }

      final details = await widget.database.importStatementFile(
        fileName: file.name,
        bytes: bytes,
        csvMapping: mapping,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        latestFuture = Future.value(details);
        loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          errorMessage = 'Não foi possível importar o arquivo.';
          loading = false;
        });
      }
    }
  }

  Future<void> promote(String batchId) async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final promoted = await widget.database.promoteImportBatchToReview(
        batchId,
      );
      final details = await widget.database.getLatestImportBatchDetails();

      if (!mounted) return;
      setState(() {
        latestFuture = Future.value(details);
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$promoted registros enviados para revisão')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        errorMessage = _friendlyImportError(error);
        loading = false;
      });
    }
  }

  void targetConfirmed(ImportBatchDetails details) {
    setState(() {
      latestFuture = Future.value(details);
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 82,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Importar arquivo',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(letterSpacing: -.5),
            ),
            const SizedBox(height: 3),
            Text(
              'CSV e OFX locais',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZimbaColors.secondaryText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<ImportBatchDetails?>(
        future: latestFuture,
        builder: (context, snapshot) {
          final details = snapshot.data;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            children: [
              ImportStepper(batch: details?.batch),
              const SizedBox(height: 16),
              if (details == null)
                ImportIntroCard(onPick: loading ? null : pickAndImport)
              else
                OutlinedButton.icon(
                  onPressed: loading ? null : pickAndImport,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('Importar outro arquivo'),
                ),
              if (loading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                ZimbaFeedbackBanner(
                  icon: Icons.error_outline,
                  title: 'Importação não concluída',
                  body: errorMessage!,
                  tone: ZimbaTone.danger,
                  action: OutlinedButton.icon(
                    onPressed: loading ? null : pickAndImport,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (snapshot.hasError)
                ZimbaStateMessage(
                  icon: Icons.error_outline,
                  title: 'Não foi possível ler a importação',
                  body:
                      'Tente abrir a tela novamente. Nenhum dado foi alterado.',
                  action: OutlinedButton.icon(
                    onPressed: () => setState(
                      () => latestFuture = widget.database
                          .getLatestImportBatchDetails(),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Atualizar'),
                  ),
                )
              else if (snapshot.connectionState == ConnectionState.waiting &&
                  details == null)
                const Center(child: CircularProgressIndicator())
              else if (details == null)
                const EmptyImportState()
              else
                Column(
                  children: [
                    ImportBatchView(
                      database: widget.database,
                      details: details,
                      onTargetConfirmed: targetConfirmed,
                      onPromote:
                          loading ||
                              details.batch.targetConfirmedAt == null ||
                              details.batch.status == 'promoted'
                          ? null
                          : () => promote(details.batch.id),
                    ),
                    const SizedBox(height: 18),
                    ImportHistoryView(
                      database: widget.database,
                      currentBatchId: details.batch.id,
                      onOpen: (batchId) => setState(
                        () => latestFuture = widget.database
                            .getImportBatchDetails(batchId),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

String _friendlyImportError(Object error) {
  final message = error.toString().replaceFirst(
    RegExp(r'^(Bad state|Invalid argument):\s*'),
    '',
  );
  return message.isEmpty ? 'Não foi possível concluir a importação.' : message;
}

class ImportIntroCard extends StatelessWidget {
  const ImportIntroCard({required this.onPick, super.key});

  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: ZimbaColors.accentSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.upload_file_outlined,
                color: ZimbaColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Importação local',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Selecione CSV ou OFX. O arquivo fica no aparelho e você confere tudo antes de salvar.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Escolher arquivo'),
          ),
        ],
      ),
    );
  }
}

class EmptyImportState extends StatelessWidget {
  const EmptyImportState({super.key});

  @override
  Widget build(BuildContext context) {
    return ZimbaCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Icon(Icons.folder_open_outlined, size: 42),
          const SizedBox(height: 10),
          Text(
            'Nenhum lote importado',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Quando você importar Nubank, Mercado Pago ou OFX, o resumo aparece aqui.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class ImportStepper extends StatelessWidget {
  const ImportStepper({required this.batch, super.key});

  final ImportBatchRow? batch;

  @override
  Widget build(BuildContext context) {
    final current = batch == null
        ? 0
        : batch!.status == 'promoted'
        ? 4
        : batch!.targetConfirmedAt == null
        ? 2
        : 3;
    const labels = ['Arquivo', 'Identif.', 'Destino', 'Prévia', 'Feito'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var index = 0; index < labels.length; index += 1)
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: index <= current
                        ? ZimbaColors.accent
                        : ZimbaColors.surfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: index <= current
                          ? Colors.white
                          : ZimbaColors.secondaryText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: index <= current
                        ? ZimbaColors.accent
                        : ZimbaColors.secondaryText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ImportHistoryView extends StatelessWidget {
  const ImportHistoryView({
    required this.database,
    required this.currentBatchId,
    required this.onOpen,
    super.key,
  });

  final AppDatabase database;
  final String currentBatchId;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImportBatchHistoryItem>>(
      future: database.listImportBatchHistory(),
      builder: (context, snapshot) {
        final history = (snapshot.data ?? const <ImportBatchHistoryItem>[])
            .where((item) => item.batch.id != currentBatchId)
            .take(5)
            .toList(growable: false);
        if (history.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'HISTÓRICO DE LOTES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: ZimbaColors.secondaryText,
                letterSpacing: .7,
              ),
            ),
            const SizedBox(height: 6),
            ZimbaCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var index = 0; index < history.length; index += 1) ...[
                    ListTile(
                      onTap: () => onOpen(history[index].batch.id),
                      leading: Icon(
                        history[index].batch.statementType == 'credit_card'
                            ? Icons.credit_card_outlined
                            : Icons.description_outlined,
                      ),
                      title: Text(
                        history[index].batch.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        history[index].target == null
                            ? '${_statementSubtitle(history[index].batch)} · sem destino'
                            : '${history[index].target!.account.name} · ${_statementSubtitle(history[index].batch)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    if (index < history.length - 1) const Divider(height: 1),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ImportBatchView extends StatelessWidget {
  const ImportBatchView({
    required this.database,
    required this.details,
    required this.onTargetConfirmed,
    required this.onPromote,
    super.key,
  });

  final AppDatabase database;
  final ImportBatchDetails details;
  final ValueChanged<ImportBatchDetails> onTargetConfirmed;
  final VoidCallback? onPromote;

  @override
  Widget build(BuildContext context) {
    final batch = details.batch;
    final visibleRecords = details.records.take(8).toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ZimbaCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                batch.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              InstrumentDisplay(
                name: instrumentProviderLabel(batch.provider),
                provider: batch.provider,
                type: 'statement',
                compact: true,
                subtitleOverride: _statementSubtitle(batch),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _MetadataPill(
                    icon: batch.statementType == 'credit_card'
                        ? Icons.credit_card_outlined
                        : Icons.account_balance_outlined,
                    label: _statementTypeLabel(batch.statementType),
                  ),
                  _MetadataPill(
                    icon: Icons.payments_outlined,
                    label: batch.currencyCode,
                  ),
                  if (batch.statementAccountId != null)
                    _MetadataPill(
                      icon: Icons.numbers,
                      label: 'Final ${_last4(batch.statementAccountId!)}',
                    ),
                  if (batch.periodStart != null || batch.periodEnd != null)
                    _MetadataPill(
                      icon: Icons.date_range_outlined,
                      label: _periodLabel(batch.periodStart, batch.periodEnd),
                    ),
                ],
              ),
              if (batch.ledgerBalanceCents != null ||
                  batch.availableBalanceCents != null) ...[
                const SizedBox(height: 8),
                Text(
                  [
                    if (batch.ledgerBalanceCents != null)
                      'Saldo ${formatBrl(batch.ledgerBalanceCents!)}',
                    if (batch.availableBalanceCents != null)
                      'Disponível ${formatBrl(batch.availableBalanceCents!)}',
                  ].join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 14),
              ImportTargetPanel(
                database: database,
                batchId: batch.id,
                locked: batch.status == 'promoted',
                onConfirmed: onTargetConfirmed,
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 88,
                children: [
                  ImportStat(label: 'Novos', value: batch.reviewRows),
                  ImportStat(label: 'Inválidos', value: batch.invalidRows),
                  ImportStat(label: 'Duplicados', value: batch.duplicateRows),
                  ImportStat(label: 'Total', value: batch.totalRows),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onPromote,
                icon: const Icon(Icons.move_to_inbox_outlined),
                label: Text(
                  batch.status == 'promoted'
                      ? 'Importação concluída'
                      : batch.targetConfirmedAt == null
                      ? 'Confirme o destino para continuar'
                      : 'Enviar novos para revisão',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'PRÉVIA DO LOTE',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: ZimbaColors.secondaryText,
            letterSpacing: .7,
          ),
        ),
        const SizedBox(height: 6),
        for (final record in visibleRecords)
          ImportPreviewRow(
            icon: _statusIcon(record.status),
            title: record.descriptionRaw ?? record.errorMessage ?? 'Registro',
            subtitle:
                '${_statusLabel(record.status)} · linha ${record.rowIndex}',
            amountCents: record.amountCents,
          ),
      ],
    );
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'duplicate' => Icons.content_copy_outlined,
      'invalid' => Icons.warning_amber_outlined,
      'promoted' => Icons.check_circle_outline,
      _ => Icons.radio_button_unchecked,
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      'duplicate' => 'Duplicado',
      'merge_candidate' => 'Possível duplicidade',
      'invalid' => 'Precisa de correção',
      'promoted' => 'Enviado para revisão',
      _ => 'Pronto para revisar',
    };
  }
}

class ImportTargetPanel extends StatefulWidget {
  const ImportTargetPanel({
    required this.database,
    required this.batchId,
    required this.locked,
    required this.onConfirmed,
    super.key,
  });

  final AppDatabase database;
  final String batchId;
  final bool locked;
  final ValueChanged<ImportBatchDetails> onConfirmed;

  @override
  State<ImportTargetPanel> createState() => _ImportTargetPanelState();
}

class _ImportTargetPanelState extends State<ImportTargetPanel> {
  late Future<ImportTargetOptions> optionsFuture;
  String? selectedAccountId;
  bool busy = false;
  String? error;

  @override
  void initState() {
    super.initState();
    optionsFuture = widget.database.getImportTargetOptions(widget.batchId);
  }

  @override
  void didUpdateWidget(covariant ImportTargetPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.batchId != widget.batchId) {
      selectedAccountId = null;
      optionsFuture = widget.database.getImportTargetOptions(widget.batchId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImportTargetOptions>(
      future: optionsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Não foi possível carregar as contas e cartões.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ZimbaColors.destructive),
          );
        }
        final data = snapshot.data;
        if (data == null) return const LinearProgressIndicator();
        final effectiveSelection =
            selectedAccountId ??
            data.batch.targetAccountId ??
            data.suggestedAccountId;
        final compatible = data.options
            .where((option) => option.assessment.compatible)
            .toList(growable: false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.batch.targetConfirmedAt == null
                        ? 'CONFIRME O DESTINO'
                        : 'DESTINO CONFIRMADO',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: data.batch.targetConfirmedAt == null
                          ? ZimbaColors.secondaryText
                          : ZimbaColors.success,
                      letterSpacing: .7,
                    ),
                  ),
                ),
                if (data.ambiguous)
                  const Tooltip(
                    message: 'Mais de um destino é compatível',
                    child: Icon(
                      Icons.warning_amber_outlined,
                      size: 18,
                      color: ZimbaColors.warning,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (compatible.isEmpty)
              const ZimbaFeedbackBanner(
                icon: Icons.add_card_outlined,
                title: 'Nenhum instrumento compatível',
                body:
                    'Cadastre a conta ou o cartão deste demonstrativo para continuar.',
                tone: ZimbaTone.warning,
              )
            else
              for (final option in compatible) ...[
                InstrumentChoice(
                  key: ValueKey(
                    'import-target-${option.instrument.account.id}',
                  ),
                  instrument: InstrumentDisplay.account(option.instrument),
                  selected: effectiveSelection == option.instrument.account.id,
                  onTap: widget.locked
                      ? () {}
                      : () => setState(
                          () =>
                              selectedAccountId = option.instrument.account.id,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 8, 8),
                  child: Text(
                    option.assessment.explanation,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ZimbaColors.secondaryText,
                    ),
                  ),
                ),
              ],
            if (!widget.locked) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: busy ? null : () => createInstrument(data.batch),
                    icon: const Icon(Icons.add),
                    label: Text(
                      data.batch.statementType == 'credit_card'
                          ? 'Cadastrar cartão'
                          : data.batch.statementType == 'bank'
                          ? 'Cadastrar conta'
                          : 'Cadastrar instrumento',
                    ),
                  ),
                  FilledButton.icon(
                    key: const ValueKey('confirm-import-target'),
                    onPressed: busy || effectiveSelection == null
                        ? null
                        : () => confirm(data, effectiveSelection),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Confirmar destino'),
                  ),
                ],
              ),
              if (error != null) ...[
                const SizedBox(height: 6),
                Text(
                  error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ZimbaColors.destructive,
                  ),
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  Future<void> confirm(ImportTargetOptions data, String accountId) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final details = await widget.database.confirmImportTarget(
        batchId: widget.batchId,
        accountId: accountId,
        reason: accountId == data.suggestedAccountId
            ? 'suggested_and_confirmed'
            : 'selected_and_confirmed',
      );
      if (!mounted) return;
      setState(() {
        busy = false;
        optionsFuture = widget.database.getImportTargetOptions(widget.batchId);
      });
      widget.onConfirmed(details);
    } catch (exception) {
      if (!mounted) return;
      setState(() {
        busy = false;
        error = _friendlyImportError(exception);
      });
    }
  }

  Future<void> createInstrument(ImportBatchRow batch) async {
    final people = await widget.database.watchPeople().first;
    if (!mounted) return;
    var type = batch.statementType;
    if (type == 'unknown') {
      type =
          await showModalBottomSheet<String>(
            context: context,
            builder: (context) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'O que deseja cadastrar?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.account_balance_outlined),
                      title: const Text('Conta'),
                      onTap: () => Navigator.pop(context, 'bank'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.credit_card_outlined),
                      title: const Text('Cartão de crédito'),
                      onTap: () => Navigator.pop(context, 'credit_card'),
                    ),
                  ],
                ),
              ),
            ),
          ) ??
          '';
    }
    if (!mounted || type.isEmpty) return;
    final initialLast4 = batch.statementAccountId == null
        ? null
        : _last4(batch.statementAccountId!);
    final navigator = Navigator.of(context);
    final accountId = type == 'credit_card'
        ? await navigator.push<String>(
            MaterialPageRoute(
              builder: (_) => CreditCardFormPage(
                database: widget.database,
                people: people,
                initialProvider: batch.provider == 'unknown'
                    ? null
                    : batch.provider,
                initialLast4: initialLast4,
              ),
            ),
          )
        : await navigator.push<String>(
            MaterialPageRoute(
              builder: (_) => AccountFormPage(
                database: widget.database,
                people: people,
                initialProvider: batch.provider == 'unknown'
                    ? null
                    : batch.provider,
                initialLast4: initialLast4,
                initialType: 'account',
              ),
            ),
          );
    if (!mounted || accountId == null) return;
    setState(() {
      selectedAccountId = accountId;
      optionsFuture = widget.database.getImportTargetOptions(widget.batchId);
    });
  }
}

class _MetadataPill extends StatelessWidget {
  const _MetadataPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ZimbaColors.surfaceMuted,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: ZimbaColors.secondaryText),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _statementSubtitle(ImportBatchRow batch) {
  final destination = batch.targetConfirmedAt == null
      ? 'destino pendente'
      : 'destino confirmado';
  return '${batch.fileFormat.toUpperCase()} · ${_statementTypeLabel(batch.statementType)} · $destination';
}

String _statementTypeLabel(String type) => switch (type) {
  'credit_card' => 'Cartão de crédito',
  'bank' => 'Conta bancária',
  _ => 'Tipo não identificado',
};

String _last4(String accountId) {
  final compact = accountId.replaceAll(RegExp('[^0-9A-Za-z]'), '');
  if (compact.length <= 4) return compact;
  return compact.substring(compact.length - 4);
}

String _periodLabel(DateTime? start, DateTime? end) {
  String date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  if (start != null && end != null) return '${date(start)}–${date(end)}';
  return date(start ?? end!);
}

class ImportPreviewRow extends StatelessWidget {
  const ImportPreviewRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amountCents,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int? amountCents;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ZimbaCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: ZimbaColors.surfaceMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, size: 17, color: ZimbaColors.secondaryText),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ZimbaColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (amountCents != null) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  formatBrl(amountCents!),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CsvMappingPage extends StatefulWidget {
  const CsvMappingPage({
    required this.fileName,
    required this.inspection,
    super.key,
  });

  final String fileName;
  final CsvFileInspection inspection;

  @override
  State<CsvMappingPage> createState() => _CsvMappingPageState();
}

class _CsvMappingPageState extends State<CsvMappingPage> {
  final formKey = GlobalKey<FormState>();
  String? dateColumn;
  String? descriptionColumn;
  String? amountColumn;
  String? externalIdColumn;

  @override
  void initState() {
    super.initState();
    final suggested = widget.inspection.suggestedMapping;
    dateColumn = suggested?.dateColumn;
    descriptionColumn = suggested?.descriptionColumn;
    amountColumn = suggested?.amountColumn;
    externalIdColumn = suggested?.externalIdColumn;
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.inspection.columns;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Text(
          'Mapear colunas',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(letterSpacing: -.5),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              ZimbaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fileName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.inspection.suggestedMapping == null
                          ? 'Escolha quais colunas representam cada informação.'
                          : 'Encontramos uma combinação provável. Confira antes de continuar.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (columns.isEmpty)
                const ZimbaCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: Icon(Icons.warning_amber_outlined),
                    title: Text('O arquivo não tem cabeçalho reconhecível.'),
                  ),
                )
              else ...[
                Text(
                  'COLUNAS DO ARQUIVO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: ZimbaColors.secondaryText,
                    letterSpacing: .7,
                  ),
                ),
                const SizedBox(height: 10),
                _ColumnField(
                  label: 'Data',
                  value: dateColumn,
                  columns: columns,
                  onChanged: (value) => setState(() => dateColumn = value),
                ),
                const SizedBox(height: 12),
                _ColumnField(
                  label: 'Descrição',
                  value: descriptionColumn,
                  columns: columns,
                  onChanged: (value) =>
                      setState(() => descriptionColumn = value),
                ),
                const SizedBox(height: 12),
                _ColumnField(
                  label: 'Valor',
                  value: amountColumn,
                  columns: columns,
                  onChanged: (value) => setState(() => amountColumn = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: externalIdColumn,
                  decoration: const InputDecoration(
                    labelText: 'Identificador (opcional)',
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Sem identificador'),
                    ),
                    for (final column in columns)
                      DropdownMenuItem<String?>(
                        value: column,
                        child: Text(
                          column,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => externalIdColumn = value),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: submit,
                  icon: const Icon(Icons.preview_outlined),
                  label: const Text('Gerar prévia'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context).pop(
      CsvImportMapping(
        dateColumn: dateColumn!,
        descriptionColumn: descriptionColumn!,
        amountColumn: amountColumn!,
        externalIdColumn: externalIdColumn,
      ),
    );
  }
}

class _ColumnField extends StatelessWidget {
  const _ColumnField({
    required this.label,
    required this.value,
    required this.columns,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> columns;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      items: [
        for (final column in columns)
          DropdownMenuItem(
            value: column,
            child: Text(column, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
      ],
      validator: (value) => value == null ? 'Escolha uma coluna' : null,
      onChanged: onChanged,
    );
  }
}

class ImportStat extends StatelessWidget {
  const ImportStat({required this.label, required this.value, super.key});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ZimbaColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(
              '$value',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
