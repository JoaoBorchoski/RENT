import 'package:flutter/material.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HorasCalendarioLocar extends StatefulWidget {
  const HorasCalendarioLocar({
    required this.calendarController,
    required this.getTimeRegions,
    required this.horaInicioLimite,
    required this.horaFimLimite,
    super.key,
  });

  final CalendarController calendarController;
  final List<TimeRegion> getTimeRegions;
  final String horaInicioLimite;
  final String horaFimLimite;

  @override
  State<HorasCalendarioLocar> createState() => _HorasCalendarioLocarState();
}

class _HorasCalendarioLocarState extends State<HorasCalendarioLocar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: SfCalendar(
        controller: widget.calendarController,
        minDate: DateTime.now(),
        viewNavigationMode: ViewNavigationMode.none,
        allowViewNavigation: false,
        showCurrentTimeIndicator: false,
        selectionDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        timeZone: 'E. South America Standard Time',
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: double.parse(widget.horaInicioLimite.split(':')[0]),
          endHour: double.parse(widget.horaFimLimite.split(':')[0]),
          timeIntervalHeight: 50,
          timeFormat: 'HH:mm',
        ),
        specialRegions: widget.getTimeRegions,
        timeRegionBuilder: (BuildContext context, TimeRegionDetails timeRegionDetails) {
          if (timeRegionDetails.region.text == 'indisponivel') {
            return Container(
              color: timeRegionDetails.region.color,
              alignment: Alignment.center,
              child: Text(
                'Indisponível',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          if (timeRegionDetails.region.text == 'selecionado') {
            return Container(
              color: timeRegionDetails.region.color,
              alignment: Alignment.center,
              child: Text(
                'Selecionado',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return Container(color: timeRegionDetails.region.color);
        },
      ),
    );
  }
}
