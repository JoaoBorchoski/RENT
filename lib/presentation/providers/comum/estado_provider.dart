import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/comum/estado_repository.dart';

var estadoProvider = [
  ChangeNotifierProxyProvider<Authentication, EstadoRepository>(create: (_) => EstadoRepository(),
    update: (ctx, auth, previous) {
      return EstadoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
