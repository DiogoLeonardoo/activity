class DateFormatter {
  static String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  static bool isAtrasada(DateTime dataLimite) {
    return DateTime.now().isAfter(dataLimite);
  }
}