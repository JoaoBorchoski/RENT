class HeaderSelectorAssociados {
  static String headerTextSelection(int activeStep) {
    switch (activeStep) {
      case 0:
        return 'Usuário';

      case 1:
        return 'Dependentes';

      default:
        return 'Associados';
    }
  }
}
