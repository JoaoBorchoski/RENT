import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/clientes/ativo_oferece_repository.dart';

var ativoOfereceProvider = [
  ChangeNotifierProxyProvider<Authentication, AtivoOfereceRepository>(
    create: (_) => AtivoOfereceRepository(),
    update: (ctx, auth, previous) {
      return AtivoOfereceRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
