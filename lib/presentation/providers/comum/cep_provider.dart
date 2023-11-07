import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/data/repositories/comum/cep_repository.dart';

var cepProvider = [
  ChangeNotifierProxyProvider<Authentication, CepRepository>(create: (_) => CepRepository(),
    update: (ctx, auth, previous) {
      return CepRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
