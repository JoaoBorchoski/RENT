import 'package:flutter/material.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/presentation/ui/authentication/avatar_page/avatar_page.dart';
import 'package:locacao/presentation/ui/authentication/home/home_page.dart';
import 'package:locacao/presentation/ui/authentication/register/aceitar_termos_page.dart';
import 'package:locacao/presentation/ui/authentication/register/register_cliente_page.dart';
import 'package:locacao/presentation/ui/authentication/register/register_page.dart';
import 'package:locacao/presentation/ui/authentication/register/register_user_page.dart';
import 'package:locacao/presentation/ui/authentication/signin/signin_page.dart';
import 'package:locacao/presentation/ui/clientes/associados/form/associados_form_page.dart';
import 'package:locacao/presentation/ui/clientes/associados/import_table/import_table.dart';
import 'package:locacao/presentation/ui/clientes/associados/list/associados_list_page.dart';
import 'package:locacao/presentation/ui/clientes/ativo/form/ativo_form_page.dart';
import 'package:locacao/presentation/ui/clientes/ativo/list/ativo_list_page.dart';
import 'package:locacao/presentation/ui/clientes/ativo_imagens/form/ativo_imagens_form_page.dart';
import 'package:locacao/presentation/ui/clientes/ativo_imagens/list/ativo_imagens_list_page.dart';
import 'package:locacao/presentation/ui/clientes/ativo_oferece/form/ativo_oferce_form_page.dart';
import 'package:locacao/presentation/ui/clientes/ativo_regras/form/ativo_regras_form_page.dart';
import 'package:locacao/presentation/ui/clientes/categorias/form/categorias_form_page.dart';
import 'package:locacao/presentation/ui/clientes/categorias/list/categorias_list_page.dart';
import 'package:locacao/presentation/ui/clientes/cliente/form/cliente_form_page.dart';
import 'package:locacao/presentation/ui/clientes/cliente/list/cliente_list_page.dart';
import 'package:locacao/presentation/ui/clientes/convidados/form/convidados_form_page.dart';
import 'package:locacao/presentation/ui/clientes/convidados/list/convidados_list_page.dart';
import 'package:locacao/presentation/ui/clientes/funcionarios/form/funcionario_form_page.dart';
import 'package:locacao/presentation/ui/clientes/funcionarios/list/funcionario_list_page.dart';
import 'package:locacao/presentation/ui/clientes/itens_locacao/form/itens_locacao_form_page.dart';
import 'package:locacao/presentation/ui/clientes/itens_locacao/list/itens_locacao_list_page.dart';
import 'package:locacao/presentation/ui/clientes/locacao_funcionario_detalhe/locacao_funcionario_detalhe_page.dart';
import 'package:locacao/presentation/ui/clientes/locacoes/form/locacoes_form_page.dart';
import 'package:locacao/presentation/ui/clientes/locacoes/list/locacoes_list_page.dart';
import 'package:locacao/presentation/ui/clientes/locacoes_funcionario/list/locacoes_funcionario_list_page.dart';
import 'package:locacao/presentation/ui/clientes/meios_pagamento_aceito/form/meios_pagamento_aceito_form_page.dart';
import 'package:locacao/presentation/ui/clientes/meios_pagamento_aceito/list/meios_pagamento_aceito_list_page.dart';
import 'package:locacao/presentation/ui/clientes/meios_pagamento_excecao/form/meios_pagamento_excecao_form_page.dart';
import 'package:locacao/presentation/ui/clientes/meios_pagamento_excecao/list/meios_pagamento_excecao_list_page.dart';
import 'package:locacao/presentation/ui/clientes/menus/menu_associados.dart';
import 'package:locacao/presentation/ui/clientes/menus/menu_ativo_page.dart';
import 'package:locacao/presentation/ui/clientes/menus/menu_meio_pagamento_page.dart';
import 'package:locacao/presentation/ui/clientes/status_associado/form/status_associados_form_page.dart';
import 'package:locacao/presentation/ui/clientes/status_associado/list/status_associados_list_page.dart';
import 'package:locacao/presentation/ui/clientes/status_ativo/form/status_ativo_form_page.dart';
import 'package:locacao/presentation/ui/clientes/status_ativo/list/status_ativo_list_page.dart';
// import 'package:locacao/presentation/ui/clientes/usuarios_locacao/form/usuarios_locacao_form_page.dart';
import 'package:locacao/presentation/ui/clientes/usuarios_locacao/list/usuarios_locacao_list_page.dart';
import 'package:locacao/presentation/ui/clientes/cliente_preferencias/form/cliente_preferencias.dart';
import 'package:locacao/presentation/ui/comum/cep/form/cep_form_page.dart';
import 'package:locacao/presentation/ui/comum/cep/list/cep_list_page.dart';
import 'package:locacao/presentation/ui/comum/cidade/form/cidade_form_page.dart';
import 'package:locacao/presentation/ui/comum/cidade/list/cidade_list_page.dart';
import 'package:locacao/presentation/ui/comum/estado/form/estado_form_page.dart';
import 'package:locacao/presentation/ui/comum/estado/list/estado_list_page.dart';
import 'package:locacao/presentation/ui/comum/meio_pagamento/form/meio_pagamento_form_page.dart';
import 'package:locacao/presentation/ui/comum/meio_pagamento/list/meio_pagamento_list_page.dart';
import 'package:locacao/presentation/ui/comum/pais/form/pais_form_page.dart';
import 'package:locacao/presentation/ui/comum/pais/list/pais_list_page.dart';
import 'package:locacao/presentation/ui/usuarios/associados_login_usuario/list/associados_usuario_login_list_page.dart';
import 'package:locacao/presentation/ui/usuarios/ativo_detalhe/ativo_detalhe_page.dart';
import 'package:locacao/presentation/ui/usuarios/dependentes/list/dependentes_list_page.dart';
import 'package:locacao/presentation/ui/usuarios/favoritos/list/favoritos_list_page.dart';
import 'package:locacao/presentation/ui/usuarios/historico_locacoes/list/historico_locacoes_list_page.dart';
import 'package:locacao/presentation/ui/usuarios/listas_negras/form/listas_negras_form_page.dart';
import 'package:locacao/presentation/ui/usuarios/listas_negras/list/listas_negras_list_page.dart';
import 'package:locacao/presentation/ui/usuarios/locacao_detalhe/locacao_detalhe_page.dart';
import 'package:locacao/presentation/ui/usuarios/locar_forms/locar_form_page.dart';
import 'package:locacao/presentation/ui/usuarios/locar_list/list/locar_list_page.dart';
import 'package:locacao/presentation/ui/usuarios/usuarios/form/usuarios_form_page.dart';
import 'package:locacao/presentation/ui/usuarios/usuarios/list/usuarios_list_page.dart';
import 'package:provider/provider.dart';

var appRoutes = <String, WidgetBuilder>{
  '/': (context) => const AuthenticationPage(),
  '/avatar': (context) => const AvatarPage(),
  '/home': (context) => const HomePage(),
  '/paises': (context) => const PaisListPage(),
  '/paises-form': (context) => const PaisFormPage(),
  '/estados': (context) => const EstadoListPage(),
  '/estados-form': (context) => const EstadoFormPage(),
  '/cidades': (context) => const CidadeListPage(),
  '/cidades-form': (context) => const CidadeFormPage(),
  '/ceps': (context) => const CepListPage(),
  '/ceps-form': (context) => const CepFormPage(),
  '/meios-pagamento': (context) => const MeioPagamentoListPage(),
  '/meios-pagamento-form': (context) => const MeioPagamentoFormPage(),
  '/clientes': (context) => const ClienteListPage(),
  '/clientes-form': (context) => const ClienteFormPage(),
  '/cliente-perfil': (context) {
    Authentication authentication = Provider.of(context, listen: false);
    final emailAutenticado = authentication.loginField;
    return ClienteFormPage(email: emailAutenticado!);
  },
  '/cliente-funcionario-perfil': (context) {
    Authentication authentication = Provider.of(context, listen: false);
    final emailAutenticado = authentication.loginField;
    return FuncionarioFormPage(email: emailAutenticado!);
  },
  '/funcionarios': (context) => const FuncionarioListPage(),
  '/funcionarios-form': (context) => const FuncionarioFormPage(),
  '/cliente-preferencias': (context) => const ClientePreferenciasFormPage(),
  '/ativos': (context) => const AtivoListPage(),
  '/ativos-detalhe': (context) => const AtivoDetalhePage(),
  '/ativos-form': (context) => const AtivoFormPage(),
  '/status-ativos': (context) => const StatusAtivoListPage(),
  '/status-ativos-form': (context) => const StatusAtivoFormPage(),
  '/locacao-funcionario': (context) => const LocacoesFuncionarioListPage(),
  '/locacao': (context) => const LocacoesListPage(),
  '/locacao-form': (context) => const LocacoesFormPage(),
  '/item-locacao': (context) => const ItensLocacaoListPage(),
  '/item-locacao-form': (context) => const ItensLocacaoFormPage(),
  '/meio-pagamento-aceito': (context) => const MeiosPagamentoAceitoListPage(),
  '/meio-pagamento-aceito-form': (context) => const MeiosPagamentoAceitoFormPage(),
  '/meio-pagamento-excecao': (context) => const MeiosPagamentoExcecaoListPage(),
  '/meio-pagamento-excecao-form': (context) => const MeiosPagamentoExcecaoFormPage(),
  '/convidado': (context) => const ConvidadosListPage(),
  '/convidado-form': (context) => const ConvidadosFormPage(),
  '/usuario-locacao': (context) => const UsuariosLocacaoListPage(),
  // '/usuario-locacao-form': (context) => const UsuariosLocacaoFormPage(),
  '/menu-associado': (context) => const MenuAssociadoPage(),
  '/associado': (context) => const AssociadosListPage(),
  '/associado-form': (context) => const AssociadosFormPage(),
  '/status-associado': (context) => const StatusAssociadoListPage(),
  '/status-associado-form': (context) => const StatusAssociadosFormPage(),
  '/categoria': (context) => const CategoriasListPage(),
  '/categoria-form': (context) => const CategoriasFormPage(),
  '/ativo-imagem': (context) => const AtivoImagensListPage(),
  '/ativo-imagem-form': (context) => const AtivoImagensFormPage(),
  '/ativo-regras-form': (context) => const AtivoRegrasFormPage(),
  '/ativo-oferece-form': (context) => const AtivoOferceFormPage(),
  '/usuario': (context) => const UsuariosListPage(),
  '/usuario-form': (context) => const UsuariosFormPage(),
  '/usuario-perfil': (context) {
    Authentication authentication = Provider.of(context, listen: false);
    final emailAutenticado = authentication.loginField;
    return UsuariosFormPage(email: emailAutenticado!);
  },
  '/dependente': (context) => const DependentesListPage(),
  '/lista-negra': (context) => const ListasNegrasListPage(),
  '/lista-negra-form': (context) => const ListasNegrasFormPage(),
  '/registro-user': (context) => const RegisterPageUser(),
  '/registro-cliente': (context) => const RegisterPageCliente(),
  '/locar': (context) => const LocarListPage(),
  '/locar-ativo': (context) => const LocarFormPage(),
  '/favoritos': (context) => const FavoritoListPage(),
  '/historico-locacoes': (context) => const HistoricoLocacoesListPage(),
  '/locacao-detalhe': (context) => const LocacaoDetalhePage(),
  '/locacao-funcionario-detalhe': (context) => const LocacaoFuncionarioDetalhePage(),
  '/registro': (context) => RegistroPage(),
  '/aceitar': (context) => AceitarTermosPage(),
  '/menu-ativos': (context) => const MenuAtivoPage(),
  '/meio-pagamento': (context) => const MenuMeioPagamentoPage(),
  '/trocar-associacao': (context) => const AssociadosUsuarioLoginListPage(),
  '/meus-dependentes': (context) => const DependentesListPage(),
  '/entrar-associcaoes': (context) => const AssociadosUsuarioLoginListPage(),
  '/associado-import-table': (context) => const AssociadoImportTable(),
};
