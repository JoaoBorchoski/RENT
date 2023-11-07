import 'package:locacao/data/repositories/clientes/favoritos_repository.dart';
import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';

var favoritosProvider = [
  ChangeNotifierProxyProvider<Authentication, FavoritoRepository>(
    create: (_) => FavoritoRepository(),
    update: (ctx, auth, previous) {
      return FavoritoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
