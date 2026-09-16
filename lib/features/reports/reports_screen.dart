import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';

enum _ReportRange { today, week, month, custom }

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  _ReportRange _range = _ReportRange.month;
  DateTimeRange? _customRange;

  DateTimeRange _resolveRange() {
    final now = DateTime.now();
    switch (_range) {
      case _ReportRange.today:
        return DateTimeRange(start: now, end: now);
      case _ReportRange.week:
        return DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now);
      case _ReportRange.month:
        return DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
      case _ReportRange.custom:
        return _customRange ?? DateTimeRange(start: now, end: now);
    }
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _customRange = picked;
        _range = _ReportRange.custom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final l10n = AppLocalizations.of(context)!;
    final range = _resolveRange();
    final txns = app.transactionRepository?.getForDateRange(range.start, range.end) ?? [];
    final sortedTxns = List.of(txns)..sort((a, b) => a.date.compareTo(b.date));
    var dueRunning = 0.0;
    var paymentRunning = 0.0;
    final dueSpots = <FlSpot>[const FlSpot(0, 0)];
    final paymentSpots = <FlSpot>[const FlSpot(0, 0)];
    for (var i = 0; i < sortedTxns.length; i++) {
      final transaction = sortedTxns[i];
      if (transaction.isDue) {
        dueRunning += transaction.amountPoysha / 100;
      } else {
        paymentRunning += transaction.amountPoysha / 100;
      }
      dueSpots.add(FlSpot((i + 1).toDouble(), dueRunning));
      paymentSpots.add(FlSpot((i + 1).toDouble(), paymentRunning));
    }

    final totalDue = txns.where((t) => t.isDue).fold<int>(0, (s, t) => s + t.amountPoysha);
    final totalPayment = txns.where((t) => t.isPayment).fold<int>(0, (s, t) => s + t.amountPoysha);

    // Top customers by outstanding balance (only positive = they owe money)
    final topCustomers = List.from(app.customers)
      ..sort((a, b) => b.balancePoysha.compareTo(a.balancePoysha));
    final topDueCustomers = topCustomers.where((c) => c.balancePoysha > 0).take(5).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reports)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _rangeChip(l10n.today, _ReportRange.today),
                _rangeChip(l10n.thisWeek, _ReportRange.week),
                _rangeChip(l10n.thisMonth, _ReportRange.month),
                ChoiceChip(
                  label: Text(l10n.reportCustom),
                  selected: _range == _ReportRange.custom,
                  onSelected: (_) => _pickCustomRange(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _reportCard(l10n.dueInPeriod, CurrencyFormatter.formatPoysha(totalDue), AppTheme.danger),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _reportCard(l10n.paymentInPeriod, CurrencyFormatter.formatPoysha(totalPayment), AppTheme.success),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _reportCard(l10n.totalOutstanding, CurrencyFormatter.formatPoysha(app.totalReceivablePoysha), AppTheme.danger),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _reportCard('মোট কাস্টমার', '${app.totalCustomers}', AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (totalDue > 0 || totalPayment > 0) ...[
            Text(l10n.dueVsPayment, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: sortedTxns.length.toDouble().clamp(1.0, double.infinity),
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _chartInterval(dueRunning, paymentRunning),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: (sortedTxns.length / 4).clamp(1.0, double.infinity),
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    _trendLine(dueSpots, AppTheme.danger),
                    _trendLine(paymentSpots, AppTheme.success),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(l10n.topDueCustomers, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          if (topDueCustomers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(l10n.noReportData, style: TextStyle(color: Colors.grey.shade600)),
            )
          else
            ...topDueCustomers.map((c) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?')),
                    title: Text(c.name),
                    trailing: Text(
                      CurrencyFormatter.formatPoysha(c.balancePoysha),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.danger),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  double _chartInterval(double due, double payment) {
    final highest = due > payment ? due : payment;
    return highest <= 0 ? 1 : (highest / 4).ceilToDouble();
  }

  LineChartBarData _trendLine(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.22,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.08),
      ),
    );
  }

  Widget _rangeChip(String label, _ReportRange value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _range == value,
        onSelected: (_) => setState(() => _range = value),
      ),
    );
  }

  Widget _reportCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
