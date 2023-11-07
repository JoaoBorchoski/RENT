import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/usuarios_locacao_repository.dart';

var usuariosLocacaoProvider = [
  ChangeNotifierProxyProvider<Authentication, UsuariosLocacaoRepository>(create: (_) => UsuariosLocacaoRepository(),
    update: (ctx, auth, previous) {
      return UsuariosLocacaoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
