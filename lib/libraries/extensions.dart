import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  /// Format number to currency
  /// 
  /// defaule format is Indonesia Rupiah (IDR)
  String toIDR({
    String locale = "id_ID",
    String symbol = "Rp ",
    int decimalDigits = 0
  }) {
    var numberFormat = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits
    );

    return numberFormat.format(this);
  }
}

extension DateTimeFormatter on DateTime {
  /// Format date time to string format
  /// 
  /// default = 18 January 2020 18:08
  /// 
  /// Default [locale] is set to Indonesia Locale
  String toDate({
    String format = 'd MMMM y HH:mm',
    String locale = 'id_ID'
  }) {
    var formatter = DateFormat(format, locale);
    return formatter.format(this);
  }

  String toDateDifferenceInformation({
    String locale = 'id_ID',
    String format = 'd MMMM y HH:mm',
  }) {
    final now = DateTime.now();
    
    final difference = now.difference(this);
    if (difference.inDays == 0) {
      if (difference.inMinutes == 0) {
        return "Baru Saja";
      } else if (difference.inMinutes < 30) {
        return "${difference.inMinutes} menit lalu";
      } else {
        // today
        var formatter = DateFormat('HH:mm', locale);
        return formatter.format(this);
      }
    } else if (difference.inDays > 0 && difference.inDays < 5) {
      return "${difference.inDays} hari lalu";
      // beberapa hari lalu
    } else {
      var formatter = DateFormat(format, locale);
      return formatter.format(this);
    }
  }
}

extension StringDateFormatter on String {
  String toDateFormat({ String format = "d MMMM y HH:mm" }) {
    if (this != null && this.isNotEmpty) {
      var dateTime = DateTime.parse(this);
      var formatter = DateFormat(format, 'id_ID');
      return formatter.format(dateTime);
    } else {
      return "";
    }
  }
}

extension StringExt on String {
  String formatDate({ String format = "d MMMM y HH:mm" }) {
    if (this != null && this.isNotEmpty) {
      var dateTime = DateTime.parse(this);
      var formatter = DateFormat(format, 'id_ID');
      return formatter.format(dateTime);
    } else {
      return "";
    }
  }

  /// Capitalize first letter of string
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}