// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class CalendarPage extends StatefulWidget {
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   late final ValueNotifier<List<Event>> _selectedEvents;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;

//   @override
//   void initState() {
//     super.initState();

//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
//   }

//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }

//   List<Event> _getEventsForDay(DateTime day) {
//     // Remplacer par la logique de récupération des événements
//     return [];
//   }

//   List<Event> _getEventsForRange(DateTime start, DateTime end) {
//     // Remplacer par la logique de récupération des événements
//     final days = daysInRange(start, end);
//     return [
//       for (final d in days) ..._getEventsForDay(d),
//     ];
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });

//       _selectedEvents.value = _getEventsForDay(selectedDay);
//     }
//   }

//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = null;
//       _focusedDay = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });

//     // `start` or `end` could be null
//     if (start != null && end != null) {
//       _selectedEvents.value = _getEventsForRange(start, end);
//     } else if (start != null) {
//       _selectedEvents.value = _getEventsForDay(start);
//     } else if (end != null) {
//       _selectedEvents.value = _getEventsForDay(end);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendrier'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           TableCalendar<Event>(
//             firstDay: DateTime.utc(2010, 10, 16),
//             lastDay: DateTime.utc(2030, 3, 14),
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             rangeStartDay: _rangeStart,
//             rangeEndDay: _rangeEnd,
//             calendarFormat: _calendarFormat,
//             rangeSelectionMode: _rangeSelectionMode,
//             eventLoader: _getEventsForDay,
//             startingDayOfWeek: StartingDayOfWeek.monday,
//             calendarStyle: CalendarStyle(
//               // Tout style de calendrier que vous souhaitez personnaliser
//               outsideDaysVisible: false,
//             ),
//             onDaySelected: _onDaySelected,
//             onRangeSelected: _onRangeSelected,
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//             },
//           ),
//           const SizedBox(height: 8.0),
//           Expanded(
//             child: ValueListenableBuilder<List<Event>>(
//               valueListenable: _selectedEvents,
//               builder: (context, value, _) {
//                 return ListView.builder(
//                   itemCount: value.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 12.0,
//                         vertical: 4.0,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: ListTile(
//                         onTap: () => print('${value[index]}'),
//                         title: Text('${value[index]}'),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Event {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }

// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }

// List<DateTime> daysInRange(DateTime start, DateTime end) {
//   final days = <DateTime>[];
//   var day = start;

//   while (day.isBefore(end)) {
//     days.add(day);
//     day = day.add(const Duration(days: 1));
//   }

//   return days;
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hopitalmap/pages/consultation/data_provider.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rendez-vous'),
      ),
      body: ListView.builder(
        itemCount: dataProvider.appointments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dataProvider.appointments[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dataProvider.addAppointment('Nouveau rendez-vous');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
