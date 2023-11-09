import 'dart:convert';
import 'package:locacao/data/repositories/common/user_repository.dart';
import 'package:locacao/data/store.dart';
import 'package:locacao/domain/models/authentication/authentication.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:locacao/shared/themes/app_images.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeySenha = GlobalKey<FormState>();
  // ignore: unused_field
  bool _isLoading = false;
  bool _loadedUser = false;
  final _controllerLogin = TextEditingController();
  final Map<String, String> _authData = {
    'login': '',
    'password': '',
  };

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> loadUserName() async {
    if (!_loadedUser) {
      _controllerLogin.text = await Store.getString('login');
      _loadedUser = true;
    }
  }

  Future<void> salveUserName() async {
    Store.saveString('login', _controllerLogin.text);
  }

  Future<void> modalConfirmacao(String mensagem) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(mensagem),
        actions: [
          ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> modalAlteraSenha(String token) async {
    var controllerSenha = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alteração de senha necessária!'),
        actions: [
          ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              final isValid = _formKeySenha.currentState?.validate() ?? false;
              if (isValid) {
                Provider.of<UserRepository>(context, listen: false)
                    .resetaSenha(base64.encode(utf8.encode(controllerSenha.text)), token)
                    .then(
                  (realizado) {
                    if (realizado) {
                      modalConfirmacao('Alterado com sucesso! Realize o login novamente')
                          .then((value) => Navigator.of(context).pop());
                    } else {
                      modalConfirmacao('Algo deu errado na alteração da senha! Tente novamente.');
                    }
                  },
                );
              }
            },
          ),
        ],
        content: SingleChildScrollView(
          child: Form(
            key: _formKeySenha,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Digite a nova senha: '),
                ),
                TextFormField(
                  controller: controllerSenha,
                  obscureText: true,
                  onSaved: (password) {
                    _authData['password'] = password ?? '';
                  },
                  validator: (password) {
                    if (password!.isEmpty) {
                      return 'Informe uma senha válida';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Confirme a senha: '),
                ),
                TextFormField(
                  obscureText: true,
                  onSaved: (confirmPassword) {
                    _authData['confirmPassword'] = confirmPassword ?? '';
                  },
                  validator: (confirmPassword) {
                    if (controllerSenha.text != confirmPassword) {
                      return 'Senhas diferentes!';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // App bar

  AppBar get buildAppBar {
    return AppBar(
      title: const Text('Login'),
      centerTitle: true,
    );
  }

  // Logo

  Widget get buildFormLogo {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        width: 250,
        height: 60,
        child: Image.asset(AppImages.signInLogo),
      ),
    );
  }

  // Email

  Widget get buildFormFieldEmail {
    return FutureBuilder(
      future: loadUserName(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 14.0,
          ),
          child: TextFormField(
            controller: _controllerLogin,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: (login) => _authData['login'] = login ?? '',
            validator: (value) => (value ?? '').isNotEmpty ? null : 'Campo obrigatório!',
          ),
        );
      },
    );
  }

  // Password

  Widget get buildFormFieldPassword {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Senha',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: AppColors.primary,
            ),
          ),
        ),
        obscureText: true,
        onSaved: (password) => _authData['password'] = base64.encode(utf8.encode(password ?? '')),
        validator: (passwordPar) {
          final password = passwordPar ?? '';
          if (password.isEmpty) {
            return 'Informe uma senha válida';
          }
          return null;
        },
      ),
    );
  }

  // Versão

  Widget get buildFormVersao {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Opacity(
        opacity: 0.2,
        child: Text('v${_packageInfo.version}'),
      ),
    );
  }

  // Logo Vamilly

  Widget get buildFormLogoVamilly {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Opacity(
        opacity: 0.2,
        child: SizedBox(
          width: 110,
          child: Image.asset(AppImages.companyLogo),
        ),
      ),
    );
  }

  // Dialog

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    salveUserName();
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Authentication authentication = Provider.of(context, listen: false);

    try {
      await authentication
          .login(
        _authData['login']!,
        _authData['password']!,
      )
          .then((tokenResetSenha) {
        if (tokenResetSenha != '') {
          modalAlteraSenha(tokenResetSenha).then((value) => Navigator.of(context).pushReplacementNamed('/'));
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    //setState(() => _isLoading = false);
  }

  Padding buildElevatedButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
            foregroundColor: MaterialStateProperty.all<Color>(AppColors.background),
          ),
          onPressed: _submit,
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Acessar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
  Padding buildOutlineButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.all(20),
            side: BorderSide(color: AppColors.primary),
          ),
          onPressed: () => {Navigator.of(context).pushReplacementNamed('/registro')},
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Cadastrar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );

  // Page

  Form buildFields(context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildFormLogo,
            buildFormFieldEmail,
            buildFormFieldPassword,
            buildElevatedButton(context),
            buildOutlineButton(context),
            buildFormLogoVamilly,
            buildFormVersao
          ],
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(child: buildFields(context))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}
