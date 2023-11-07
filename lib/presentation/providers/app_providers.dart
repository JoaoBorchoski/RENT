import 'package:locacao/presentation/providers/clientes/ativo_regras_provider.dart';
import 'package:locacao/presentation/providers/clientes/cliente_preferencias_provider.dart';
import 'package:locacao/presentation/providers/clientes/funcionario_provider.dart';
import 'package:locacao/presentation/providers/clientes/status_associados_provider.dart';
import 'package:locacao/presentation/providers/common/termo_uso_provider.dart';
import 'package:locacao/presentation/providers/common/user_provider.dart';
import 'package:locacao/presentation/providers/usuarios/favoritos_provider.dart';

import './authentication/authentication_provider.dart';
import './comum/pais_provider.dart';
import './comum/estado_provider.dart';
import './comum/cidade_provider.dart';
import './comum/cep_provider.dart';
import './comum/meio_pagamento_provider.dart';
import './clientes/cliente_provider.dart';
import './clientes/ativo_provider.dart';
import './clientes/status_ativo_provider.dart';
import './clientes/locacoes_provider.dart';
import './clientes/itens_locacao_provider.dart';
import './clientes/meios_pagamento_aceito_provider.dart';
import './clientes/meios_pagamento_excecao_provider.dart';
import './clientes/convidados_provider.dart';
import './clientes/usuarios_locacao_provider.dart';
import './clientes/associados_provider.dart';
import './clientes/categorias_provider.dart';
import './clientes/ativo_imagens_provider.dart';
import './usuarios/usuarios_provider.dart';
import './usuarios/dependentes_provider.dart';
import './usuarios/listas_negras_provider.dart';
import 'clientes/ativo_oferece_provider.dart';

mixin AppProviders {
  static var providers = [
    ...authenticationProvider,
    ...paisProvider,
    ...estadoProvider,
    ...cidadeProvider,
    ...cepProvider,
    ...meioPagamentoProvider,
    ...clienteProvider,
    ...clientePreferenciasProvider,
    ...funcionarioProvider,
    ...ativoProvider,
    ...statusAtivoProvider,
    ...locacoesProvider,
    ...itensLocacaoProvider,
    ...meiosPagamentoAceitoProvider,
    ...meiosPagamentoExcecaoProvider,
    ...convidadosProvider,
    ...usuariosLocacaoProvider,
    ...associadosProvider,
    ...statusAssociadosProvider,
    ...categoriasProvider,
    ...ativoImagensProvider,
    ...ativoRegraProvider,
    ...ativoOfereceProvider,
    ...usuariosProvider,
    ...dependentesProvider,
    ...listasNegrasProvider,
    ...favoritosProvider,
    ...userProvider,
    ...termoUsoProvider
  ];
}
