import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart'; // Importar el archivo generado
import 'settings_page.dart'; // Página de configuración
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // Para convertir la lista de vacas a JSON
import 'package:intl/intl.dart'; 


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('es'); // Idioma inicial
  List<Cow> _cows = [];

  // Función para cambiar el idioma
  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCows().then((loadedCows) {
      setState(() {
        _cows = loadedCows;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,  // Agregar esta línea
      ],
      supportedLocales: [
        Locale('en', ''), // Inglés
        Locale('es', ''), // Español
      ],
      home: HomeScreen(onLanguageChange: _changeLanguage, cows: _cows, onAddCow: _addCow),
    );
  }

  // Agregar vaca y guardar
  void _addCow(Cow cow) {
    setState(() {
      _cows.add(cow);
    });
    _saveCows(_cows);  // Guardar vacas después de agregar una
  }
}

class HomeScreen extends StatefulWidget {
  final Function(String) onLanguageChange;
  final List<Cow> cows;
  final Function(Cow) onAddCow;

  const HomeScreen({
    super.key,
    required this.onLanguageChange,
    required this.cows,
    required this.onAddCow,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    final pregnantCows = widget.cows.where((cow) => cow.isPregnant).toList();
    final nonPregnantCows = widget.cows.where((cow) => !cow.isPregnant).toList();

    _pages.clear();
    _pages.add(PregnantCowsPage(cows: pregnantCows));
    _pages.add(NonPregnantCowsPage(cows: nonPregnantCows));
    _pages.add(CalendarPage(cows: pregnantCows)); // Pasar vacas preñadas

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.app_title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    onLanguageChange: widget.onLanguageChange,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pregnant_woman),
            label: S.current.pregnant,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.not_interested),
            label: S.current.non_pregnant,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: S.current.calendar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCowPage(onAddCow: widget.onAddCow),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Cow {
  final String name; // Nombre de la vaca
  final DateTime pregnancyDate; // Fecha de embarazo
  final bool isPregnant; // Estado de embarazo (preñada o no preñada)

  Cow({
    required this.name,
    required this.pregnancyDate,
    required this.isPregnant,
  });

  // Método para calcular la fecha de parto
  DateTime get dueDate {
    return pregnancyDate.add(Duration(days: 280)); // 280 días de gestación
  }
}

class PregnantCowsPage extends StatelessWidget {
  final List<Cow> cows;

  const PregnantCowsPage({super.key, required this.cows});

  @override
  Widget build(BuildContext context) {
    // Filtrar las vacas preñadas
    final pregnantCows = cows.where((cow) => cow.isPregnant).toList();
    return ListView.builder(
      itemCount: pregnantCows.length,
      itemBuilder: (context, index) {
        final cow = pregnantCows[index];
        return ListTile(
          title: Text(cow.name),
          subtitle: Text('Fecha de embarazo: ${cow.pregnancyDate.toLocal()} \nFecha de parto estimada: ${cow.dueDate.toLocal()}'),
        );
      },
    );
  }
}

class NonPregnantCowsPage extends StatelessWidget {
  final List<Cow> cows;

  const NonPregnantCowsPage({super.key, required this.cows});

  @override
  Widget build(BuildContext context) {
    // Filtrar las vacas no preñadas
    final nonPregnantCows = cows.where((cow) => !cow.isPregnant).toList();
    return ListView.builder(
      itemCount: nonPregnantCows.length,
      itemBuilder: (context, index) {
        final cow = nonPregnantCows[index];
        return ListTile(
          title: Text(cow.name),
          subtitle: Text('No está preñada.'),
        );
      },
    );
  }
}

class AddCowPage extends StatefulWidget {
  final Function(Cow) onAddCow;

  const AddCowPage({super.key, required this.onAddCow});

  @override
  _AddCowPageState createState() => _AddCowPageState();
}

class _AddCowPageState extends State<AddCowPage> {
  final _nameController = TextEditingController();
  DateTime _pregnancyDate = DateTime.now();
  bool _isPregnant = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.add_cow_page_title)),  // Título de la página
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: S.current.cow_name,  // Usar texto localizado para el label
              ),
            ),
            ListTile(
              title: Text("${S.current.pregnancy_date}: ${_pregnancyDate.toLocal()}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _pregnancyDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null && selectedDate != _pregnancyDate) {
                  setState(() {
                    _pregnancyDate = selectedDate;
                  });
                }
              },
            ),
            SwitchListTile(
              title: Text(S.current.is_pregnant),  // Usar texto localizado
              value: _isPregnant,
              onChanged: (bool value) {
                setState(() {
                  _isPregnant = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  final newCow = Cow(
                    name: _nameController.text,
                    pregnancyDate: _pregnancyDate,
                    isPregnant: _isPregnant,
                  );
                  widget.onAddCow(newCow);
                  Navigator.pop(context);
                }
              },
              child: Text(S.current.add_cow_button),  // Usar texto localizado
            ),
          ],
        ),
      ),
    );
  }
}

class CowEvent {
  final String cowId; // Identificador de la vaca
  final String description; // Detalles opcionales del evento

  CowEvent({required this.cowId, required this.description});
}

Map<DateTime, List<CowEvent>> cowEvents = {
  DateTime(2024, 1, 10): [
    CowEvent(cowId: '001', description: 'Vaca 001 dará a luz'),
    CowEvent(cowId: '002', description: 'Vaca 002 dará a luz'),
  ],
  DateTime(2024, 1, 15): [
    CowEvent(cowId: '003', description: 'Vaca 003 dará a luz'),
  ],
};

class CalendarPage extends StatefulWidget {
  final List<Cow> cows;

  const CalendarPage({Key? key, required this.cows}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now(); // Día seleccionado
  DateTime _focusedDay = DateTime.now(); // Día en el calendario enfocado
  List<Cow> _cowsForSelectedDay = []; // Vacas filtradas para el día seleccionado

  @override
  void initState() {
    super.initState();
    _filterCowsByDate(_selectedDay);
  }

  // Filtrar las vacas por fecha de parto (dueDate)
  void _filterCowsByDate(DateTime selectedDate) {
    setState(() {
      _cowsForSelectedDay = widget.cows
          .where((cow) => cow.dueDate.isSameDayAs(selectedDate)) // Filtramos por la fecha de parto
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario de Partos')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 01, 01),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) {
              // Devolver las vacas cuya fecha de parto coincida con el día
              return widget.cows
                  .where((cow) => cow.dueDate.isSameDayAs(day)) // Filtramos por la fecha de parto
                  .toList();
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _filterCowsByDate(selectedDay); // Filtra las vacas al seleccionar una nueva fecha
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarFormat: CalendarFormat.month,
            calendarBuilders: CalendarBuilders(
              // Personalizamos la apariencia de los días marcados
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    right: 1,
                    child: Icon(
                      Icons.circle, // Icono para el marcador
                      size: 5,
                      color: Colors.blue, // Color del marcador
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cowsForSelectedDay.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Vaca ${_cowsForSelectedDay[index].name}'),
                  subtitle: Text('Fecha estimada de parto: ${DateFormat('dd/MM/yyyy').format(_cowsForSelectedDay[index].dueDate)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension DateCompare on DateTime {
  bool isSameDayAs(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}

Future<void> _saveCows(List<Cow> cows) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cowList = cows.map((cow) => jsonEncode({
    'name': cow.name,
    'pregnancyDate': cow.pregnancyDate.toIso8601String(),
    'isPregnant': cow.isPregnant,
  })).toList();
  await prefs.setStringList('cows', cowList);
}

Future<List<Cow>> _loadCows() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cowList = prefs.getStringList('cows');
  if (cowList != null) {
    return cowList.map((cowJson) {
      final Map<String, dynamic> cowMap = jsonDecode(cowJson);
      return Cow(
        name: cowMap['name'],
        pregnancyDate: DateTime.parse(cowMap['pregnancyDate']),
        isPregnant: cowMap['isPregnant'],
      );
    }).toList();
  }
  return []; // Si no hay vacas guardadas, retorna una lista vacía
}

class CowCalendarPage extends StatefulWidget {
  const CowCalendarPage({super.key});

  @override
  _CowCalendarPageState createState() => _CowCalendarPageState();
}

class _CowCalendarPageState extends State<CowCalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Partos'),
      ),
      body: Column(
        children: [
          TableCalendar<CowEvent>(
            firstDay: DateTime(2023),
            lastDay: DateTime(2025),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return cowEvents[day] ?? [];
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = cowEvents[_selectedDay] ?? [];
    if (events.isEmpty) {
      return Center(
        child: Text('No hay eventos para este día'),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          leading: Icon(Icons.pets),
          title: Text(event.cowId),
          subtitle: Text(event.description),
        );
      },
    );
  }
}