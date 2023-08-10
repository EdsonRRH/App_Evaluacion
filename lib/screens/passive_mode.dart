import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wear/wear.dart';
import 'package:weather/weather.dart';

class DateDark extends StatelessWidget {
  const DateDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.only(top: 10.0), // Ajusta el valor según sea necesario
        child: Stack(
          children: [
            TempDark(),
            ClimaDark(),
            ClockIcon()
          ],
        ),
      ),
    );
  }
}

class TempDark extends StatefulWidget {
  const TempDark({Key? key}) : super(key: key);

  @override
  _TempDarkState createState() => _TempDarkState();
}

class _TempDarkState extends State<TempDark> {
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
                      DateFormat('a').format(snapshot.data!); // AM o PM

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 88, 33, 33)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formattedDateNom,
                            style: const TextStyle(fontSize: 24,color: Color.fromARGB(255, 88, 33, 33)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formattedMonth,
                            style: const TextStyle(
                                fontSize: 24, color: Color.fromARGB(255, 35, 158, 24)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedTimeH,
                            style: const TextStyle(
                                fontSize: 25, color: Color.fromARGB(255, 35, 158, 24)),
                          ),
                          Text(
                            formattedTimeM,
                            style: const TextStyle(fontSize: 25,color: Color.fromARGB(255, 4, 104, 74)),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            amPm,
                            style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 4, 104, 74)),
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


class ClimaDark extends StatefulWidget {
  const ClimaDark({Key? key}) : super(key: key);

  @override
  _ClimaDarkState createState() => _ClimaDarkState();
}

class _ClimaDarkState extends State<ClimaDark> {
  late WeatherFactory _weatherFactory;
  Weather? _currentWeather;
  String _location = 'QUERETARO';

  @override
  void initState() {
    super.initState();
    _weatherFactory = WeatherFactory("aac83942afd154a270c70503f850b402",
        language: Language.SPANISH);
    _getCurrentWeather();
  }

  Future<void> _getCurrentWeather() async {
    try {
      Weather? weather =
          await _weatherFactory.currentWeatherByCityName(_location);
      if (mounted) {
        setState(() {
          _currentWeather = weather;
        });
      }
    } catch (e) {
      print('Error al obtener el clima: $e');
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
            margin: const EdgeInsets.only(bottom: 40),
            child: _currentWeather != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_currentWeather!.temperature?.celsius?.toStringAsFixed(1) ?? 'N/A'}°C',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 110, 6, 6)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _currentWeather?.areaName ?? 'N/A',
                            style: const TextStyle(fontSize: 15, color: Color.fromARGB(255, 110, 6, 6)),
                          ),
                        ],
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}


class ClockIcon extends StatelessWidget {
  const ClockIcon({Key? key}) : super(key: key);

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
            color: Colors.white, // Color del icono
          ),
        );
      },
    );
  }
}
