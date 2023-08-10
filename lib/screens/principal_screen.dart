import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wear/wear.dart';
import 'package:weather/weather.dart';

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 3, 11, 22), Color.fromARGB(255, 5, 16, 41), Color.fromARGB(255, 6, 31, 51)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Stack(
            children: [
              DateWidget(),
              ClimaScreen(),
              Clock(),
            ],
          ),
        ),
      ),
    );
  }
}


class DateWidget extends StatefulWidget {
  const DateWidget({Key? key}) : super(key: key);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late Stream<DateTime> timeStream;
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    timeStream = Stream<DateTime>.periodic(
        const Duration(seconds: 1), (_) => DateTime.now());
    dateFormat = DateFormat('yyyy-MM-dd');
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return Center(
          child: Container(
            width: 200, // Tamaño fijo para el ancho
            height: 200, // Tamaño fijo para la altura
            child: StreamBuilder<DateTime>(
              stream: timeStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  String formattedTimeH =
                      DateFormat('h:').format(snapshot.data!);
                  String formattedTimeM =
                      DateFormat('mm').format(snapshot.data!);
                  String formattedDate =
                      DateFormat('d').format(snapshot.data!);
                  String formattedDateNom =
                      DateFormat('EEEE').format(snapshot.data!);
                  String formattedMonth =
                      DateFormat('MMMM').format(snapshot.data!);
                  String amPm =
                      DateFormat('a').format(snapshot.data!); 

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 24, color: Color.fromARGB(255, 202, 115, 14)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formattedDateNom,
                            style: const TextStyle(
                              fontSize: 24, color: Color.fromARGB(255, 202, 115, 14)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formattedMonth,
                            style: const TextStyle(
                                fontSize: 24, color: Color.fromARGB(255, 202, 115, 14)),
                          ),
                          
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedTimeH,
                            style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 181, 212, 4),fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formattedTimeM,
                            style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 181, 212, 4),fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            amPm,
                            style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 181, 212, 4),fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClimaScreenState createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  late WeatherFactory _weatherFactory;
  Weather? _currentWeather;
  final String _location = 'QUERETARO';

  @override
  void initState() {
    super.initState();
    _weatherFactory = WeatherFactory("aac83942afd154a270c70503f850b402",
        language: Language.SPANISH);
    _getCurrentWeather();
  }

  Future<void> _getCurrentWeather() async {
    Weather? weather =
        await _weatherFactory.currentWeatherByCityName(_location);
    if (mounted) {
      setState(() {
        _currentWeather = weather;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        var screenSize = MediaQuery.of(context).size;
        final shapeForm = WatchShape.of(context);

        if (shapeForm == WearShape.round) {
          screenSize = Size(
            (screenSize.width / 2) * 1.4142,
            (screenSize.height / 2) * 1.4142,
          );
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 40),
            child: _currentWeather != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_currentWeather!.temperature?.celsius?.toStringAsFixed(1) ?? 'N/A'}°C',
                            style: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 8, 209, 176),fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _currentWeather?.areaName ?? 'N/A',
                            style: const TextStyle(fontSize: 18,color: Color.fromARGB(255, 8, 209, 176),fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class Clock extends StatelessWidget {
  const Clock({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        var screenSize = MediaQuery.of(context).size;
        final shapeForm = WatchShape.of(context);

        if (shapeForm == WearShape.round) {
          screenSize = Size(
            (screenSize.width / 2) * 1.4142,
            (screenSize.height / 2) * 1.4142,
          );
        }

        return const Align(
          alignment: Alignment.topCenter,
          child: Icon(
            Icons.watch, // Icono de reloj
            size: 40, // Tamaño del icono
            color: Color.fromARGB(255, 181, 212, 4), // Color del icono
          ),
        );
      },
    );
  }
}