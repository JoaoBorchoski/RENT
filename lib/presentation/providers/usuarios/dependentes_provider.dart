import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/usuarios/dependentes_repository.dart';

var dependentesProvider = [
  ChangeNotifierProxyProvider<Authentication, DependentesRepository>(create: (_) => DependentesRepository(),
    update: (ctx, auth, previous) {
      return DependentesRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
