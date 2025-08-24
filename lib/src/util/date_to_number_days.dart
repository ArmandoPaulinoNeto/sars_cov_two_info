import 'package:intl/intl.dart';

class DateToNumberDays{

  DateTime ?dateInitial;

  DateToNumberDays(String dateInitial){

    this.dateInitial = DateFormat('dd/MM/yyyy').parse(dateInitial);
    print(dateInitial);
  }

  String numberDays(){
    int difference = DateTime.now().difference(dateInitial!).inDays;
    return difference.toString();
  }
}