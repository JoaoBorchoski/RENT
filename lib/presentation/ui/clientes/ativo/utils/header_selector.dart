class HeaderSelector {
  static String headerTextSelection(int activeStep) {
    switch (activeStep) {
      case 0:
        return 'Informações básicas';

      case 1:
        return 'Limites do Ativo';

      case 2:
        return 'Imagens do Ativo';

      case 3:
        return 'O que o ativo oferece?';

      case 4:
        return 'Regras do ativo';

      case 5:
        return 'Resumo do ativo';

      default:
        return 'Ativo';
    }
  }
}
