import 'package:flutter/material.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../bookings/data/models/booking_api_response.dart';
import '../../../../bookings/data/models/global_app_data.dart';

class PieChartCard extends StatefulWidget {
  final GlobalAppData globalData;

  const PieChartCard({super.key, required this.globalData });

  @override
  State<PieChartCard> createState() => _PieChartCardState();
}

class _PieChartCardState extends State<PieChartCard> {


  Map<String, double> dataMap = {};
  List<Color> colorList = <Color>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataMap = getEnvironmentDataMap(widget.globalData.bookingData.bookingList);
    colorList=getColorList(dataMap);
  }

  List<Color> getColorList(Map<String, double> dataMap) {
    List<Color> colorList = [];
    int index = 0;


    for (var key in dataMap.keys) {
      colorList.add(predefinedColors[index % predefinedColors.length]);
      index++;
    }

    return colorList;
  }

  Map<String, double> getEnvironmentDataMap(List<Booking> bookings) {
    if (bookings.isEmpty) return {};

    // Count occurrences of each environmentName
    Map<String, int> environmentCounts = {};
    for (var booking in bookings) {
      environmentCounts[booking.environmentName] =
          (environmentCounts[booking.environmentName] ?? 0) + 1;
    }

    int totalBookings = bookings.length;

    // Convert counts into percentage-based formatted keys
    Map<String, double> dataMap = {};
    environmentCounts.forEach((env, count) {
      double percentage = (count / totalBookings) * 100;
      String formattedKey = "$env ${percentage.toStringAsFixed(0)}%";
      dataMap[formattedKey] = count.toDouble();
    });

    return dataMap;
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 320,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ), // Padding between cards
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  "Environment Utilization",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 12,
                  chartRadius: 180,
                  // colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  // centerText: "TEST",
                  centerWidget: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectableText(
                          '${widget.globalData.bookingData.bookingList.length}',
                          style: TextStyle(
                            color: AppColors.textDarkGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          '  100%',
                          style: TextStyle(
                            color: AppColors.textLightGrey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: false,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: true,
                    decimalPlaces: 1,
                  ),
                  // gradientList: ---To add gradient colors---
                  // emptyColorGradient: ---Empty Color gradient---
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
