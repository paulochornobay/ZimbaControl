import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../data/local/app_database.dart';
import 'dashboard_page.dart';

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
        setState(() {
          loading = false;
        });
        return;
      }

      final details = await widget.database.importStatementFile(
        fileName: file.name,
        bytes: bytes,
      );

      setState(() {
        latestFuture = Future.value(details);
        loading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Nao foi possivel importar o arquivo.';
        loading = false;
      });
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Importar'),
            Text(
              'CSV e OFX locais',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: FutureBuilder<ImportBatchDetails?>(
        future: latestFuture,
        builder: (context, snapshot) {
          final details = snapshot.data;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              ImportIntroCard(onPick: loading ? null : pickAndImport),
              if (loading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
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
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Importacao local',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Selecione CSV ou OFX. O arquivo fica no aparelho e os registros entram primeiro em staging.',
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
      ),
    );
  }
}

class EmptyImportState extends StatelessWidget {
  const EmptyImportState({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
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
              'Quando voce importar Nubank, Mercado Pago ou OFX, o resumo aparece aqui.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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
        Card(
          elevation: 0,
          child: Padding(
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
                  '${batch.provider} · ${batch.fileFormat.toUpperCase()} · ${batch.fileHash.substring(0, 10)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ImportStat(label: 'Novos', value: batch.reviewRows),
                    ImportStat(label: 'Invalidos', value: batch.invalidRows),
                    ImportStat(label: 'Duplicados', value: batch.duplicateRows),
                    ImportStat(label: 'Total', value: batch.totalRows),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onPromote,
                  icon: const Icon(Icons.move_to_inbox_outlined),
                  label: const Text('Enviar novos para revisao'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('Previa', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        for (final record in visibleRecords)
          Card(
            elevation: 0,
            child: ListTile(
              dense: true,
              leading: Icon(_statusIcon(record.status)),
              title: Text(
                record.descriptionRaw ?? record.errorMessage ?? 'Registro',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${record.status} · linha ${record.rowIndex}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: record.amountCents == null
                  ? null
                  : Text(
                      formatBrl(record.amountCents!),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
            ),
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
}

class ImportStat extends StatelessWidget {
  const ImportStat({required this.label, required this.value, super.key});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
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
