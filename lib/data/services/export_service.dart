import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/gait_result.dart';
import '../models/sensor_data.dart';
import '../models/semiogram_reference.dart';
import '../models/user_profile.dart';

/// Builds and shares the recorded accelerometer + gyroscope time series as a
/// CSV file, and the analysis summary as a PDF report.
class ExportService {
  /// Returns the written CSV [File] (also used by the backend phase to
  /// upload to Firebase Storage).
  Future<File> buildTimeseriesCsv(
    List<SensorData> data, {
    String? sessionId,
  }) async {
    final buffer = StringBuffer()
      ..writeln('index,timestamp_ms,accX,accY,accZ,gyrX,gyrY,gyrZ,foot');
    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      buffer.writeln(
        '$i,${d.timestamp},${d.accX},${d.accY},${d.accZ},'
        '${d.gyrX},${d.gyrY},${d.gyrZ},${d.footSide}',
      );
    }
    final dir = await getTemporaryDirectory();
    final id = sessionId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final file = File('${dir.path}/gait_timeseries_$id.csv');
    await file.writeAsString(buffer.toString());
    return file;
  }

  Future<void> shareTimeseriesCsv(
    List<SensorData> data, {
    String? sessionId,
  }) async {
    final file = await buildTimeseriesCsv(data, sessionId: sessionId);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Gait time series',
      text: 'Accelerometer & gyroscope time series '
          '(${data.length} samples).',
    );
  }

  /// Builds the analysis report as PDF bytes.
  Future<Uint8List> buildReportPdf({
    required GaitResult result,
    required UserProfile profile,
    DateTime? date,
  }) async {
    final doc = pw.Document();
    final scores = buildSemiogramScores(result.semiogram);
    final when = date ?? DateTime.now();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Gait Analysis Report',
                style: pw.TextStyle(
                    fontSize: 22, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text('Generated: ${when.toIso8601String()}'),
          pw.SizedBox(height: 12),
          pw.Text('Subject',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Bullet(
              text: 'Name: ${profile.name.isEmpty ? '-' : profile.name}'),
          pw.Bullet(
              text: 'Gender: ${profile.gender == 'M' ? 'Male' : 'Female'}'),
          pw.Bullet(text: 'Age: ${profile.age} years'),
          pw.Bullet(
              text: 'Height: ${profile.heightM} m  ·  '
                  'Weight: ${profile.weightKg} kg  ·  '
                  'BMI: ${profile.bmi.toStringAsFixed(1)}'),
          pw.SizedBox(height: 12),
          pw.Text('Result',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Bullet(
              text: 'FMA-LE Score: ${result.fmaLeScore} / 34 '
                  '(${result.severity})'),
          pw.Bullet(
              text: 'Classification: ${result.classification} '
                  '(${(result.confidence * 100).round()}% confidence)'),
          pw.SizedBox(height: 12),
          pw.Text('Semiogram parameters',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Criteria',
              'Parameter',
              'Mean',
              'SD',
              'Z-coef',
              'Subject',
              'Z'
            ],
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerStyle: pw.TextStyle(
                fontSize: 9, fontWeight: pw.FontWeight.bold),
            data: scores
                .map((s) => [
                      s.param.criteria,
                      '${s.param.name} (${s.param.unit})',
                      s.param.mean.toStringAsFixed(2),
                      s.param.sd.toStringAsFixed(2),
                      s.param.zSign,
                      s.value.toStringAsFixed(2),
                      '${s.z >= 0 ? '+' : ''}${s.z.toStringAsFixed(2)}',
                    ])
                .toList(),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Z = (value − mean) / SD against the reference population. '
            'The Z-coefficient sign marks whether higher (+) or lower (−) '
            'is clinically favourable.',
            style: const pw.TextStyle(
                fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    return doc.save();
  }

  Future<void> shareReportPdf({
    required GaitResult result,
    required UserProfile profile,
    DateTime? date,
  }) async {
    final bytes = await buildReportPdf(
        result: result, profile: profile, date: date);
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          'gait_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
