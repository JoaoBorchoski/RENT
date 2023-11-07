import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/associados_repository.dart';

var associadosProvider = [
  ChangeNotifierProxyProvider<Authentication, AssociadosRepository>(create: (_) => AssociadosRepository(),
    update: (ctx, auth, previous) {
      return AssociadosRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
