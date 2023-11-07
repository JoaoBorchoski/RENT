import 'package:locacao/data/repositories/common/termo_uso_repository.dart';
import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';

var termoUsoProvider = [
  ChangeNotifierProxyProvider<Authentication, TermoUsoRepository>(
    create: (_) => TermoUsoRepository(),
    update: (ctx, auth, previous) {
      return TermoUsoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
