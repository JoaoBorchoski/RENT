import 'package:provider/provider.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';

var authenticationProvider = [
  ChangeNotifierProvider(create: (_) => Authentication(),
  ),
];
