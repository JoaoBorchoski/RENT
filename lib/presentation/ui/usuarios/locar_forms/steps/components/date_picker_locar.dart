import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerLocar extends StatefulWidget {
  const DatePickerLocar({
    required this.datePickerController,
    required this.specialDates,
    required this.blackoutDates,
    required this.onSelectionChanged,
    required this.limiteAntecedenciaLocar,
    super.key,
  });

  final DateRangePickerController datePickerController;
  final Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  final List<DateTime> specialDates;
  final List<DateTime> blackoutDates;
  final int limiteAntecedenciaLocar;

  @override
  State<DatePickerLocar> createState() => _DatePickerLocarState();
}

class _DatePickerLocarState extends State<DatePickerLocar> {
  final Color monthCellBackground = AppColors.lightGrey;
  final Color indicatorColor = AppColors.success;
  final Color highlightColor = AppColors.secondDegrade;
  final Color cellTextColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      width: 600,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                SizedBox(
                  height: 450,
                  child: Card(
                    elevation: 6,
                    margin: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      color: Colors.white,
                      child: SfDateRangePicker(
                        controller: widget.datePickerController,
                        onSelectionChanged: widget.onSelectionChanged,
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(Duration(days: 30 * widget.limiteAntecedenciaLocar)),
                        headerHeight: 50,
                        selectionMode: DateRangePickerSelectionMode.single,
                        headerStyle: DateRangePickerHeaderStyle(
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: cellTextColor,
                            )),
                        showNavigationArrow: true,
                        selectionShape: DateRangePickerSelectionShape.rectangle,
                        selectionColor: highlightColor,
                        monthViewSettings: DateRangePickerMonthViewSettings(
                          blackoutDates: widget.blackoutDates,
                          firstDayOfWeek: 7,
                          viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: TextStyle(
                              fontSize: 10,
                              color: cellTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          dayFormat: 'EEE',
                          specialDates: widget.specialDates,
                        ),
                        selectionTextStyle: const TextStyle(color: Colors.white),
                        monthCellStyle: DateRangePickerMonthCellStyle(
                          cellDecoration: _MonthCellDecoration(
                            backgroundColor: monthCellBackground,
                            showIndicator: false,
                            indicatorColor: indicatorColor,
                          ),
                          todayCellDecoration: _MonthCellDecoration(
                            borderColor: highlightColor,
                            backgroundColor: monthCellBackground,
                            showIndicator: false,
                            indicatorColor: indicatorColor,
                          ),
                          specialDatesDecoration: _MonthCellDecoration(
                            backgroundColor: monthCellBackground,
                            showIndicator: true,
                            indicatorColor: indicatorColor,
                          ),
                          disabledDatesTextStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          blackoutDatesDecoration: _MonthCellDecoration(
                            backgroundColor: Colors.red,
                            showIndicator: false,
                            indicatorColor: indicatorColor,
                          ),
                          blackoutDateTextStyle: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                          ),
                          textStyle: TextStyle(color: cellTextColor, fontSize: 14),
                          specialDatesTextStyle: TextStyle(color: cellTextColor, fontSize: 14),
                          todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
                        ),
                        monthFormat: 'MMM',
                        yearCellStyle: DateRangePickerYearCellStyle(
                          todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
                          textStyle: TextStyle(color: cellTextColor, fontSize: 14),
                          disabledDatesTextStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                          leadingDatesTextStyle: TextStyle(color: cellTextColor.withOpacity(0.5), fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 1, child: Container())
        ],
      ),
    );
  }
}

class _MonthCellDecoration extends Decoration {
  const _MonthCellDecoration(
      {this.borderColor, this.backgroundColor, required this.showIndicator, this.indicatorColor});

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MonthCellDecorationPainter(
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      showIndicator: showIndicator,
      indicatorColor: indicatorColor,
    );
  }
}

class _MonthCellDecorationPainter extends BoxPainter {
  _MonthCellDecorationPainter(
      {this.borderColor, this.backgroundColor, required this.showIndicator, this.indicatorColor});

  final Color? borderColor;
  final Color? backgroundColor;
  final bool showIndicator;
  final Color? indicatorColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & configuration.size!;
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    final Paint paint = Paint()..color = backgroundColor!;
    canvas.drawRRect(RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    if (borderColor != null) {
      paint.color = borderColor!;
      canvas.drawRRect(RRect.fromRectAndRadius(bounds, const Radius.circular(5)), paint);
    }

    if (showIndicator) {
      paint.color = indicatorColor!;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bounds.right - 6, bounds.top + 6), 2.5, paint);
    }
  }
}
