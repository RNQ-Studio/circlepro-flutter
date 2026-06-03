import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/manah_colors.dart';
import '../../../../theme/manah_text_styles.dart';
import '../../../../theme/manah_tokens.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../events_providers.dart';

class DigitalScorecardScreen extends ConsumerStatefulWidget {
  const DigitalScorecardScreen({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  ConsumerState<DigitalScorecardScreen> createState() => _DigitalScorecardScreenState();
}

class _DigitalScorecardScreenState extends ConsumerState<DigitalScorecardScreen> {
  final List<Offset?> _athleteSignature = [];
  final List<Offset?> _judgeSignature = [];
  bool _isSigned = false;

  @override
  Widget build(BuildContext context) {
    final asyncTickets = ref.watch(myTicketsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Skor Digital'),
        elevation: 0,
      ),
      body: asyncTickets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat tiket: $err')),
        data: (tickets) {
          final ticket = tickets.firstWhere(
            (t) => t.id == widget.ticketId,
            orElse: () => throw Exception('Tiket tidak ditemukan'),
          );

          final eventId = ticket.event?.id;
          final divisionId = ticket.eventDivisionId;
          final targetButt = ticket.targetButt;

          if (eventId == null || targetButt == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(ManahSpacing.base),
                child: Text('Bantalan target belum dialokasikan untuk tiket ini. Silakan hubungi panitia.'),
              ),
            );
          }

          final asyncScorecard = ref.watch(targetScorecardProvider(
            eventId: eventId,
            divisionId: divisionId,
            targetButt: targetButt,
          ));

          return asyncScorecard.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Gagal memuat data skoring: $err')),
            data: (archers) {
              final archer = archers.firstWhere(
                (a) => a.registrationId == ticket.id,
                orElse: () => throw Exception('Data pemanah tidak ditemukan pada target ini'),
              );

              final session = archer.scoringSession;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(ManahSpacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Athlete & Target Header
                    _buildArcherHeader(archer, isDark),
                    const SizedBox(height: ManahSpacing.base),

                    // FITA Score Grid
                    _buildFitaGrid(session, isDark),
                    const SizedBox(height: ManahSpacing.lg),

                    // Signature Pads
                    if (!_isSigned) ...[
                      Text(
                        'Konfirmasi & Tanda Tangan',
                        style: ManahTextStyles.h3,
                      ),
                      const SizedBox(height: ManahSpacing.sm),
                      Text(
                        'Silakan berikan tanda tangan persetujuan skor oleh Atlet dan Juri di bawah ini.',
                        style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                      ),
                      const SizedBox(height: ManahSpacing.base),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanda Tangan Atlet', style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                SignaturePad(
                                  points: _athleteSignature,
                                  onChanged: (pts) {
                                    setState(() {
                                      _athleteSignature.clear();
                                      _athleteSignature.addAll(pts);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: ManahSpacing.base),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanda Tangan Juri', style: ManahTextStyles.bodyM.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                SignaturePad(
                                  points: _judgeSignature,
                                  onChanged: (pts) {
                                    setState(() {
                                      _judgeSignature.clear();
                                      _judgeSignature.addAll(pts);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: ManahSpacing.lg),
                      ElevatedButton(
                        onPressed: (_athleteSignature.isEmpty || _judgeSignature.isEmpty)
                            ? null
                            : () {
                                setState(() {
                                  _isSigned = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Kartu skor digital berhasil ditandatangani dan dikonfirmasi.'),
                                    backgroundColor: ManahColors.success,
                                  ),
                                );
                              },
                        child: const Text('Simpan Kartu Skor'),
                      ),
                    ] else ...[
                      // Confirmed Signatures View
                      Container(
                        padding: const EdgeInsets.all(ManahSpacing.base),
                        decoration: BoxDecoration(
                          color: ManahColors.success.withValues(alpha: 0.1),
                          border: Border.all(color: ManahColors.success),
                          borderRadius: BorderRadius.circular(ManahBorderRadius.card),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.verified, color: ManahColors.success),
                                SizedBox(width: 8),
                                Text(
                                  'KARTU SKOR DIKONFIRMASI',
                                  style: TextStyle(
                                    color: ManahColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: ManahSpacing.base),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Atlet', style: ManahTextStyles.bodyS),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 100,
                                      height: 60,
                                      color: Colors.white,
                                      child: CustomPaint(
                                        painter: SignaturePainter(points: _athleteSignature),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(archer.userName, style: ManahTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Juri', style: ManahTextStyles.bodyS),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 100,
                                      height: 60,
                                      color: Colors.white,
                                      child: CustomPaint(
                                        painter: SignaturePainter(points: _judgeSignature),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text('Juri Lapangan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildArcherHeader(dynamic archer, bool isDark) {
    return Card(
      elevation: 0,
      color: isDark ? ManahColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ManahBorderRadius.card),
        side: BorderSide(color: isDark ? Colors.grey[850]! : Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ManahSpacing.base),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: ManahColors.brand,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${archer.targetButt}${archer.targetLetter}',
                style: ManahTextStyles.h2.copyWith(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(width: ManahSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    archer.userName,
                    style: ManahTextStyles.h3,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Nomor BIB: ${archer.bibNumber ?? "-"}',
                    style: ManahTextStyles.bodyS.copyWith(color: ManahColors.mediumGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFitaGrid(ScoringSessionEntity session, bool isDark) {
    final ends = session.ends;

    return Table(
      border: TableBorder.all(
        color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.2), // End #
        1: FlexColumnWidth(1),   // A1
        2: FlexColumnWidth(1),   // A2
        3: FlexColumnWidth(1),   // A3
        4: FlexColumnWidth(1),   // A4
        5: FlexColumnWidth(1),   // A5
        6: FlexColumnWidth(1),   // A6
        7: FlexColumnWidth(1.5), // Subtotal
        8: FlexColumnWidth(1.8), // Cumulative
        9: FlexColumnWidth(1.2), // 10+X
        10: FlexColumnWidth(1),  // X
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
          ),
          children: [
            _buildGridHeader('End'),
            _buildGridHeader('1'),
            _buildGridHeader('2'),
            _buildGridHeader('3'),
            _buildGridHeader('4'),
            _buildGridHeader('5'),
            _buildGridHeader('6'),
            _buildGridHeader('Sub'),
            _buildGridHeader('Total'),
            _buildGridHeader('10+X'),
            _buildGridHeader('X'),
          ],
        ),

        // Data Rows
        ...List.generate(session.numEnds, (endIdx) {
          final endNumber = endIdx + 1;
          final end = ends.firstWhere(
            (e) => e.endNumber == endNumber,
            orElse: () => ScoringEndEntity(id: '', endNumber: endNumber, arrows: const []),
          );

          // Subtotal
          final subtotal = end.endTotal;

          // Cumulative
          int cumulative = 0;
          for (int i = 0; i <= endIdx; i++) {
            final prevEnd = ends.firstWhere(
              (e) => e.endNumber == (i + 1),
              orElse: () => const ScoringEndEntity(id: '', endNumber: 0, arrows: []),
            );
            cumulative += prevEnd.endTotal;
          }

          // 10+X and X counts for this end
          final tenPlusX = end.arrows.where((a) => a.scoreValue == 10 || a.isX).length;
          final xCount = end.arrows.where((a) => a.isX).length;

          return TableRow(
            children: [
              _buildGridCell('$endNumber', isBold: true),
              ...List.generate(6, (arrIdx) {
                if (arrIdx < end.arrows.length) {
                  final arrow = end.arrows[arrIdx];
                  return _buildGridCell(arrow.displayValue,
                      color: ManahColors.forScore(arrow.scoreValue, isX: arrow.isX, isMiss: arrow.isMiss));
                }
                return _buildGridCell('-');
              }),
              _buildGridCell('$subtotal', isBold: true),
              _buildGridCell('$cumulative', isBold: true, color: ManahColors.brand),
              _buildGridCell('$tenPlusX'),
              _buildGridCell('$xCount'),
            ],
          );
        }),

        // Summary Row
        TableRow(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
          ),
          children: [
            _buildGridCell('Total', isBold: true),
            _buildGridCell(''),
            _buildGridCell(''),
            _buildGridCell(''),
            _buildGridCell(''),
            _buildGridCell(''),
            _buildGridCell(''),
            _buildGridCell(''),
            _buildGridCell('${session.totalScore}', isBold: true, color: ManahColors.brand),
            _buildGridCell('${session.tenCount}', isBold: true),
            _buildGridCell('${session.xCount}', isBold: true),
          ],
        ),
      ],
    );
  }

  Widget _buildGridHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: ManahTextStyles.bodyS.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGridCell(String text, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: ManahTextStyles.bodyS.copyWith(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}

class SignaturePad extends StatefulWidget {
  const SignaturePad({
    super.key,
    required this.points,
    required this.onChanged,
  });

  final List<Offset?> points;
  final ValueChanged<List<Offset?>> onChanged;

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset localPosition = renderBox.globalToLocal(details.globalPosition);
              widget.points.add(localPosition);
              widget.onChanged(List.from(widget.points));
            },
            onPanEnd: (details) {
              widget.points.add(null);
              widget.onChanged(List.from(widget.points));
            },
            child: CustomPaint(
              painter: SignaturePainter(points: widget.points),
              size: Size.infinite,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: IconButton(
              icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
              onPressed: () {
                setState(() {
                  widget.points.clear();
                  widget.onChanged([]);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter({required this.points});
  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) => true;
}
