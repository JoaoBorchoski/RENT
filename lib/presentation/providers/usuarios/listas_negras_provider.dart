import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/usuarios/listas_negras_repository.dart';

var listasNegrasProvider = [
  ChangeNotifierProxyProvider<Authentication, ListasNegrasRepository>(create: (_) => ListasNegrasRepository(),
    update: (ctx, auth, previous) {
      return ListasNegrasRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
