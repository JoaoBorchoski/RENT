DateTime parseToDateTime(String date, String time) {
  List<String> dataSplit = date.split(' ')[0].split('-');
  List<String> horaSplit = time.split(':');

  int ano = int.parse(dataSplit[0]);
  int mes = int.parse(dataSplit[1]);
  int dia = int.parse(dataSplit[2]);
  int hora = int.parse(horaSplit[0]);
  int minuto = int.parse(horaSplit[1]);

  DateTime dateTime = DateTime(ano, mes, dia, hora, minuto);
  return dateTime;
}
