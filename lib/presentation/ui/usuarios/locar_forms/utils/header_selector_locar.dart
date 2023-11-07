class HeaderSelector {
  static String headerTextSelection(int activeStep) {
    switch (activeStep) {
      case 0:
        return 'Data e Hora';

      case 1:
        return 'Convidados';

      case 2:
        return 'Pagamento';

      case 3:
        return 'Finalizar locação';

      default:
        return 'Ativo';
    }
  }
}
