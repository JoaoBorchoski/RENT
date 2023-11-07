// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/clientes/cliente_repository.dart';
import 'package:locacao/data/repositories/common/user_repository.dart';
import 'package:locacao/data/repositories/usuarios/usuarios_repository.dart';
import 'package:locacao/presentation/components/app_loading.dart';
import 'package:locacao/presentation/components/app_main_menu.dart';
import 'package:locacao/presentation/components/app_scaffold.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTipo();
  }

  String tipoUsuario = '';

  Future<void> _fetchTipo() async {
    Authentication authentication = Provider.of(context, listen: false);

    try {
      tipoUsuario = await Provider.of<UserRepository>(context, listen: false)
          .verificaTipoUsuario(authentication.loginField)
          .then((value) => authentication.tipoUser = value);

      if (tipoUsuario == "Usuario") {
        await Provider.of<UsuariosRepository>(context, listen: false)
            .getByEmail(authentication.loginField!)
            .then((value) {
          if (value.id != null) {
            authentication.usuarioClienteId = value.id;
            Navigator.of(context).pushReplacementNamed('/entrar-associcaoes');
          } else {
            Navigator.of(context).pushReplacementNamed('/usuario-form', arguments: {"firstLogin": true});
          }
        }).catchError((error) {
          // Handle error
          setState(() {
            _isLoading = false;
          });
        });
      } else if (tipoUsuario == "Cliente") {
        await Provider.of<ClienteRepository>(context, listen: false)
            .getByEmail(authentication.loginField!)
            .then((value) {
          if (value.id != null) {
            authentication.usuarioClienteId = value.id;
            setState(() {
              _isLoading = false;
            });
          } else {
            Navigator.of(context).pushReplacementNamed('/clientes-form', arguments: {"firstLogin": true});
          }
        }).catchError((error) {
          // Handle error
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadWidget();
    } else {
      return AppScaffold(
        title: const Text('Rent'),
        showDrawer: true,
        body: AppMainMenu(),
      );
    }
  }
}
