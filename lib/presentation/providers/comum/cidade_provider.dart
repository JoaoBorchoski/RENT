import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/comum/cidade_repository.dart';

var cidadeProvider = [
  ChangeNotifierProxyProvider<Authentication, CidadeRepository>(create: (_) => CidadeRepository(),
    update: (ctx, auth, previous) {
      return CidadeRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
