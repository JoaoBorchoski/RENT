import 'package:locacao/data/repositories/common/user_repository.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:provider/provider.dart';

var userProvider = [
  ChangeNotifierProxyProvider<Authentication, UserRepository>(create: (_) => UserRepository(),
    update: (ctx, auth, previous) {
      return UserRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
