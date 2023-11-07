import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/usuarios/usuarios_repository.dart';

var usuariosProvider = [
  ChangeNotifierProxyProvider<Authentication, UsuariosRepository>(create: (_) => UsuariosRepository(),
    update: (ctx, auth, previous) {
      return UsuariosRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
