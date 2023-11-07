import 'package:locacao/data/repositories/clientes/status_associados_repository.dart';
import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';

var statusAssociadosProvider = [
  ChangeNotifierProxyProvider<Authentication, StatusAssociadosRepository>(
    create: (_) => StatusAssociadosRepository(),
    update: (ctx, auth, previous) {
      return StatusAssociadosRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
