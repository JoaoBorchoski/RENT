import 'package:locacao/data/repositories/clientes/funcionario_repository.dart';
import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';

var funcionarioProvider = [
  ChangeNotifierProxyProvider<Authentication, FuncionarioRepository>(
    create: (_) => FuncionarioRepository(),
    update: (ctx, auth, previous) {
      return FuncionarioRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
