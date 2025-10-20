import 'package:intl/intl.dart';

dynamic formatNairaPrice(double price) {
  var formatCurrency = NumberFormat.currency(
    locale: 'en_NG', // Nigerian locale
    symbol: '₦',
    decimalDigits: 2, // set to 0 if you want no decimal places
  );
  return formatCurrency.format(price);
}
