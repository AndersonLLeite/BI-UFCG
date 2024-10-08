import 'package:bi_ufcg/shared/ui/styles/colors_app.dart';
import 'package:bi_ufcg/shared/widgets/widget_no_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/indicator.dart';

class PieChartDistribuition extends StatefulWidget {
  final Map<String, Map<String, num>> dataMap; // Dados gerais

  const PieChartDistribuition({
    Key? key,
    required this.dataMap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PieChartDistribuitionState();
}

class _PieChartDistribuitionState extends State<PieChartDistribuition> {
  int touchedIndex = -1;
  bool showPercentage = true;
  String selectedPeriod = 'Todos os Períodos';

  @override
  Widget build(BuildContext context) {
    List<String> periods = [
      'Períodos Selecionados',
      ...widget.dataMap.keys,
    ];

    // Verifica se o período selecionado ainda existe nos dados
    if (!periods.contains(selectedPeriod)) {
      setState(() {
        selectedPeriod = 'Períodos Selecionados';
      });
    }

    // Dados filtrados ou combinados conforme o período selecionado
    final Map<String, num> filteredData = <String, num>{};
    if (selectedPeriod == 'Períodos Selecionados') {
      widget.dataMap.forEach((_, data) {
        data.forEach((key, value) {
          if (filteredData.containsKey(key)) {
            filteredData[key] = filteredData[key]! + value;
          } else {
            filteredData[key] = value;
          }
        });
      });
    } else if (widget.dataMap.containsKey(selectedPeriod)) {
      filteredData.addAll(widget.dataMap[selectedPeriod]!);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: filteredData.isEmpty
            ? const WidgetNoData()
            : Card(
                key: const ValueKey('chart'),
                color: context.colors.chartCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: Column(
                    children: [
                      // Dropdown para selecionar o período
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              dropdownColor: context.colors.primary,
                              value: selectedPeriod,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPeriod = newValue!;
                                });
                              },
                              items: periods.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              showPercentage
                                  ? Icons.percent
                                  : Icons.format_list_numbered,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                showPercentage = !showPercentage;
                              });
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Tooltip(
                                  message: touchedIndex != -1
                                      ? filteredData.entries
                                          .elementAt(touchedIndex)
                                          .key
                                      : '',
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          setState(() {
                                            if (event
                                                    .isInterestedForInteractions &&
                                                pieTouchResponse != null &&
                                                pieTouchResponse
                                                        .touchedSection !=
                                                    null) {
                                              touchedIndex = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            } else {
                                              touchedIndex = -1;
                                            }
                                          });
                                        },
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: showingSections(filteredData),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildIndicators(filteredData),
                              ),
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // Cria as seções do gráfico de pizza
  List<PieChartSectionData> showingSections(Map<String, num> filteredData) {
    final total = filteredData.values.reduce((a, b) => a + b).toDouble();

    return List.generate(filteredData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 40.0 : 14.0;
      final radius = isTouched ? 80.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final entry = filteredData.entries.elementAt(i);
      final percentage = (entry.value.toDouble() / total) * 100;

      // Formatação do título
      String title = showPercentage
          ? '${percentage.toStringAsFixed(1)}%'
          : (entry.value.toDouble() % 1 == 0
              ? entry.value
                  .toInt()
                  .toString() // Sem casas decimais se for inteiro
              : entry.value
                  .toDouble()
                  .toStringAsFixed(2)); // Com uma casa decimal se for quebrado

      return PieChartSectionData(
        color: ColorsApp.getColorForIndex(i), // Cor dinâmica para cada política
        value: entry.value.toDouble(),
        title: title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  // Constrói os indicadores dinamicamente
  List<Widget> _buildIndicators(Map<String, num> filteredData) {
    return List.generate(filteredData.length, (index) {
      final key = filteredData.keys.elementAt(index);
      final color = ColorsApp.getColorForIndex(index);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Indicator(
          color: color,
          text: key,
          isSquare: true,
        ),
      );
    });
  }
}
