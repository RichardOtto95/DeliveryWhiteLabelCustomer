class Time {
  Time(
    this.date, {
    this.capitalize = false,
    this.completeWeekDay = false,
    this.upperCase = false,
  });

  DateTime date;

  bool capitalize;

  bool completeWeekDay;

  bool upperCase;

  List<String> weekDays = [
    "domingo",
    "segunda",
    "terça",
    "quarta",
    "quinta",
    "sexta",
    "sábado",
  ];

  List<String> completeWeekDays = [
    "domingo",
    "segunda-feira",
    "terça-feira",
    "quarta-feira",
    "quinta-feira",
    "sexta-feira",
    "sábado",
  ];

  List<String> months = [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro",
  ];

  /// foramat: segunda
  String weekDay({
    bool upperCase = false,
    bool completeWeekDay = false,
    bool capitalize = false,
  }) {
    String weekDay = completeWeekDay
        ? completeWeekDays[date.weekday]
        : weekDays[date.weekday];

    if (capitalize) {
      weekDay = weekDay[0].toUpperCase() + weekDay.substring(1);
    }

    if (upperCase) {
      weekDay = weekDay.toUpperCase();
    }
    return weekDay;
  }

  /// foramat: janeiro
  String month() {
    String month = months[date.month - 1];

    if (capitalize) {
      month = month[0].toUpperCase() + month.substring(1);
    }

    if (upperCase) {
      month = month.toUpperCase();
    }
    return month;
  }

  /// foramat: XX/XX/XXXX
  String dayDate({bool dotted = false}) {
    String _date =
        "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year}";
    if (dotted) {
      _date.replaceAll("/", ".");
    }
    return _date;
  }

  /// foramat: XX:XX
  String hour() =>
      "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";

  /// foramat: hoje XX/XX/XXXX XX:XX
  String completeDate({
    bool dotted = false,
  }) =>
      "${day()} ${dayDate(dotted: dotted)} ${hour()}";

  /// foramat: hoje ou ontem ou anteontem ou sabado ou terça
  String day({
    bool numDay = false,
  }) {
    String? nextDay = nextDays();

    if (nextDay != null) {
      return nextDay;
    }
    return weekDay(
      capitalize: capitalize,
      completeWeekDay: completeWeekDay,
      upperCase: upperCase,
    );
  }

  String? nextDays() {
    final now = DateTime.now();
    if (date.toString().substring(0, 10) == now.toString().substring(0, 10)) {
      return upperCase
          ? "HOJE"
          : capitalize
              ? "Hoje"
              : "hoje";
    }
    if (date.toString().substring(0, 6) == now.toString().substring(0, 6)) {
      if (date.day == now.day - 1) {
        return upperCase
            ? "ONTEM"
            : capitalize
                ? "Ontem"
                : "ontem";
      }
      if (date.day == now.day - 2) {
        return upperCase
            ? "ANTEONTEM"
            : capitalize
                ? "Anteontem"
                : "anteontem";
      }
    }
    return null;
  }

  /// foramat: sabado XX:XX
  String dayHour() => "${day()} ${hour()}";

  String chatTime() {
    String? nextDay = nextDays();
    if (nextDay != null) return nextDay;
    return dayDate();
  }
}
