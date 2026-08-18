import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../application/import_parser.dart';
import '../data/local/app_database.dart';
import 'dashboard_page.dart';
import 'design/zimba_theme.dart';
import 'design/zimba_ui.dart';

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

    final promoted = await widget.database.promoteImportBatchToReview(batchId);
    final details = await widget.database.getLatestImportBatchDetails();

    if (!mounted) {
      return;
    }

    setState(() {
      latestFuture = Future.value(details);
      loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$promoted registros enviados para revisao')),
    );
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
              ImportIntroCard(onPick: loading ? null : pickAndImport),
              if (loading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                ZimbaCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: const Icon(Icons.error_outline),
                    title: Text(errorMessage!),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (snapshot.connectionState == ConnectionState.waiting &&
                  details == null)
                const Center(child: CircularProgressIndicator())
              else if (details == null)
                const EmptyImportState()
              else
                ImportBatchView(
                  details: details,
                  onPromote: loading || details.batch.reviewRows == 0
                      ? null
                      : () => promote(details.batch.id),
                ),
            ],
          );
        },
      ),
    );
  }
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

class ImportBatchView extends StatelessWidget {
  const ImportBatchView({
    required this.details,
    required this.onPromote,
    super.key,
  });

  final ImportBatchDetails details;
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
              Text(
                '${_providerLabel(batch.provider)} · ${batch.fileFormat.toUpperCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.3,
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
                label: const Text('Enviar novos para revisão'),
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

  String _providerLabel(String provider) {
    return switch (provider) {
      'nubank' => 'Nubank',
      'mercado_pago' => 'Mercado Pago',
      _ => 'Outro banco',
    };
  }
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
