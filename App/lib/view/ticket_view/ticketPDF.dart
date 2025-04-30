import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_application_1/data/ticket.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/utilities/constant.dart';

class TicketPdfPage extends StatelessWidget {
  final Ticket ticket;

  TicketPdfPage({required this.ticket});

  Future<pw.Document> generatePdf() async {
    final pdf = pw.Document();
    String formattedDate = DateFormat('dd-MM-yyyy').format(ticket.penayangan!.tanggal_tayang!);
    final image = await loadImage('${ticket.film!.poster_1}'.isNotEmpty ? '${ticket.film!.poster_1}' : 'https://via.placeholder.com/200x300');

    // Load logo image
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('images/loadLogo.png')).buffer.asUint8List(),
    );

    // Generate QR code image
    final qrCodeImage = await _generateQrCode(ticket.idTiket.toString());

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          margin: pw.EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          theme: pw.ThemeData(),
        ),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColors.black,
              borderRadius: pw.BorderRadius.circular(15),
            ),
            child: pw.Column(
              children: [
                // Top Section with curved design
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.black,
                    borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(15)),
                  ),
                  padding: pw.EdgeInsets.all(20),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(logoImage, width: 80, height: 40),
                      pw.Text(
                        'E-Ticket Atma Cinema',
                        style: pw.TextStyle(
                          fontSize: 24,
                          color: PdfColors.amber500,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  child:  pw.Expanded(
                        child: pw.Container(
                          height: 2,
                          color: PdfColors.amber500,
                          margin: pw.EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                )
                ,

                // Movie Details Section
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: pw.Row(
                    children: [
                      // Left side - Poster
                      pw.Container(
                        width: 120,
                        height: 180,
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(10),
                          boxShadow: [
                            pw.BoxShadow(
                              color: PdfColors.amber500,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: pw.ClipRRect(
                          horizontalRadius: 10,
                          verticalRadius: 10,
                          child: pw.Image(image, fit: pw.BoxFit.cover),
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${ticket.film!.judul}',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.amber500,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              '${ticket.film!.genre}',
                              style: pw.TextStyle(
                                fontSize: 14,
                                color: PdfColors.amber400,
                              ),
                            ),
                            pw.SizedBox(height: 15),
                            _buildInfoRow('Bioskop', '${ticket.bioskop!.namaBioskop}'),
                            _buildInfoRow('Tanggal', formattedDate),
                            _buildInfoRow('Jam', '${ticket.sesi!.jam_mulai} WIB'),
                            _buildInfoRow('Studio', '${ticket.studio!.nama_studio}'),
                            _buildInfoRow('Kursi', '${ticket.nomorKursi}'), 
                            _buildInfoRow('Harga', 'Rp ${ticket.penayangan!.harga_tiket}'), 
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider with decorative edges
                pw.Container(
                  margin: pw.EdgeInsets.symmetric(horizontal: 20),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 15,
                        height: 30,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.amber500,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          height: 2,
                          color: PdfColors.amber500,
                          margin: pw.EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      pw.Container(
                        width: 15,
                        height: 30,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.amber500,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Section
                // Bottom Section with centered QR and text
                pw.Container(
                  padding: pw.EdgeInsets.all(20),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      // QR Code
                      pw.Container(
                        padding: pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          borderRadius: pw.BorderRadius.circular(10),
                          boxShadow: [
                            pw.BoxShadow(
                              color: PdfColors.grey300,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: pw.Image(qrCodeImage, width: 100, height: 100),
                      ),
                      pw.SizedBox(height: 15),
                      // Ticket ID and Additional Info
                      pw.Column(
                        children: [
                          pw.Text(
                            'Ticket ID: ${ticket.idTiket}',
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.amber500,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Enjoy Your Movie!',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.amber500,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 100),
                          pw.Text(
                            'Thank you for choosing Atma Cinema!',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.amber500,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 60,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.amber500,
              ),
            ),
          ),
          pw.Text(
            ': ',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.amber500,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.amber500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<pw.ImageProvider> loadImage(String imageUrl) async {
    final ByteData data = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
    final Uint8List bytes = data.buffer.asUint8List();
    return pw.MemoryImage(bytes);
  }

  Future<pw.ImageProvider> _generateQrCode(String ticketId) async {
    final qrPainter = QrPainter(
      data: ticketId,
      version: QrVersions.auto,
      gapless: true,
    );

    final data = await qrPainter.toImageData(200);
    return pw.MemoryImage(data!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Your Ticket',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<pw.Document>(
        future: generatePdf(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final pdf = snapshot.data!;
            return PdfPreview(
              build: (format) async => pdf.save(),
              canChangePageFormat: false,
              canDebug: false,
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}