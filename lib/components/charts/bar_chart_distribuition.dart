import 'package:bi_ufcg/shared/ui/styles/colors_app.dart';
import 'package:bi_ufcg/shared/widgets/widget_no_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartDistribuition extends StatefulWidget {
  final Map<String, Map<String, double>> dataMap; // Dados no formato genérico

  const BarChartDistribuition({
    Key? key,
    required this.dataMap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BarChartDistribuitionState();
}

class _BarChartDistribuitionState extends State<BarChartDistribuition> {
  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.dataMap.isEmpty) {
      return const WidgetNoData();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: Card(
          key: const ValueKey('chart'),
          color: context.colors.chartCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          child: AspectRatio(
            aspectRatio: 1.6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceBetween,
                          borderData: FlBorderData(
                            show: true,
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              drawBehindEverything: true,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 36,
                                getTitlesWidget: (value, meta) {
                                  final categories = _getCategories();
                                  final index = value.toInt();
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      categories[index].length > 3
                                          ? categories[index].substring(0, 3)
                                          : categories[index], // Exibe 3 letras
                                      style: TextStyle(
                                        color: touchedGroupIndex == index
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(),
                            topTitles: AxisTitles(),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            ),
                          ),
                          barGroups: _generateBarGroups(),
                          maxY: _getMaxY() + 10,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.white,
                              getTooltipItem: (
                                group,
                                groupIndex,
                                rod,
                                rodIndex,
                              ) {
                                final categories = _getCategories();
                                final categoryName = categories[groupIndex];
                                final value = rod.toY;

                                // Formatação do valor para tooltip
                                final formattedValue = value % 1 == 0
                                    ? value.toInt().toString()
                                    : value.toStringAsFixed(2);

                                return BarTooltipItem(
                                  '$categoryName\n$formattedValue',
                                  TextStyle(
                                    color: rod.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            touchCallback: (event, response) {
                              if (event.isInterestedForInteractions &&
                                  response != null &&
                                  response.spot != null) {
                                setState(() {
                                  touchedGroupIndex =
                                      response.spot!.touchedBarGroupIndex;
                                });
                              } else {
                                setState(() {
                                  touchedGroupIndex = -1;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Gera os grupos de barras para o gráfico
  List<BarChartGroupData> _generateBarGroups() {
    final combinedData = _combineData();

    final sortedCategories = combinedData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return List.generate(sortedCategories.length, (index) {
      final entry = sortedCategories[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: ColorsApp.getColorForIndex(index), // Cor dinâmica
            width: 10,
          ),
        ],
        showingTooltipIndicators: touchedGroupIndex == index ? [0] : [],
      );
    });
  }

  // Combina os dados de todos os períodos em um único mapa
  Map<String, double> _combineData() {
    final combinedData = <String, double>{};

    widget.dataMap.forEach((_, dataMap) {
      dataMap.forEach((category, count) {
        combinedData[category] = (combinedData[category] ?? 0) + count;
      });
    });

    return combinedData;
  }

  // Obter o valor máximo para o eixo Y
  double _getMaxY() {
    final combinedData = _combineData();
    return combinedData.values.reduce((a, b) => a > b ? a : b).toDouble();
  }

  // Obter os nomes das categorias
  List<String> _getCategories() {
    final combinedData = _combineData();
    final sortedCategories = combinedData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedCategories.map((entry) => entry.key).toList();
  }
}
