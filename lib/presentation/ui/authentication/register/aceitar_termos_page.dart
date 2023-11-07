import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:locacao/data/repositories/common/termo_uso_repository.dart';
import 'package:locacao/data/repositories/common/user_repository.dart';
import 'package:locacao/domain/models/common/termo_uso.dart';
import 'package:locacao/presentation/components/app_pop_error_dialog.dart';
import 'package:locacao/presentation/components/app_pop_success_dialog.dart';
import 'package:locacao/shared/exceptions/auth_exception.dart';
import 'package:locacao/shared/themes/app_colors.dart';
import 'package:provider/provider.dart';

class AceitarTermosPage extends StatefulWidget {
  const AceitarTermosPage({super.key});

  @override
  State<AceitarTermosPage> createState() => _AceitarTermosPageState();
}

class _AceitarTermosPageState extends State<AceitarTermosPage> {
  bool _isChecked = false;
  TermoUso termoUsoAceito = TermoUso();

  Future<void> _registerAccount(Map<String, dynamic> data) async {
    try {
      Provider.of<UserRepository>(context, listen: false).register(data).then((value) async {
        if (value != "") {
          termoUsoAceito.userId = value;
          _getIpModeloDispositivo();
        } else {
          return showDialog(
            context: context,
            builder: (context) {
              return AppPopErrorDialog(
                message: 'Email já cadastrado!',
              );
            },
          ).then(
            (value) => {
              if (!value)
                {
                  Navigator.of(context).pushReplacementNamed('/'),
                }
            },
          );
        }
      });
    } on AuthException catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(message: error.toString());
        },
      );
    } catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return AppPopErrorDialog(message: 'Ocorreu um erro inesperado!');
        },
      );
    }
  }

  Future<void> _registarAceitoTermo() async {
    await Provider.of<TermoUsoRepository>(context, listen: false).save({
      "id": '',
      "userId": termoUsoAceito.userId,
      "ip": termoUsoAceito.ip,
      "modeloDispositivo": termoUsoAceito.modeloDispositivo,
    }).then((value) => {
          if (value)
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AppPopSuccessDialog(
                    message: 'Registrado com sucesso',
                  );
                },
              ).then(
                (value) => {
                  if (!value)
                    {
                      Navigator.of(context).pushReplacementNamed('/'),
                    }
                },
              )
            },
        });
  }

  void _aceito(Map<String, dynamic> data) async {
    if (_isChecked) {
      _registerAccount(data);
    }
  }

  void _getIpModeloDispositivo() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        termoUsoAceito.ip = addr.address;
      }
    }
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      termoUsoAceito.modeloDispositivo = iosDeviceInfo.identifierForVendor ?? "";
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      termoUsoAceito.modeloDispositivo = androidDeviceInfo.model;
    }
    _registarAceitoTermo();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;

    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Termos de Aceitação"),
            Text("Bem-vindo! Antes de prosseguir com o uso de nossos serviços, é importante que você leia e aceite nossos termos e condições. Ao utilizar nosso aplicativo/website/serviço, você está concordando com os seguintes termos:"),
            Text("Uso do Serviço:"),
            Text("Ao utilizar nosso serviço, você concorda em fazê-lo apenas para fins legítimos. Você não deve utilizar o serviço para qualquer atividade ilegal, fraudulenta, prejudicial ou não autorizada."),
            Text("Propriedade Intelectual:"),
            Text("Todo o conteúdo presente em nosso serviço, incluindo, mas não limitado a, textos, gráficos, logotipos, ícones, imagens, clipes de áudio, downloads digitais e compilações de dados, é propriedade exclusiva da nossa empresa e está protegido pelas leis de propriedade intelectual aplicáveis. Você não tem permissão para copiar, distribuir, modificar, exibir, reproduzir, publicar ou criar trabalhos derivados a partir de qualquer conteúdo encontrado em nosso serviço, a menos que tenha recebido autorização expressa por escrito da nossa parte."),
            Text("Privacidade:"),
            Text("Respeitamos sua privacidade e tratamos seus dados pessoais de acordo com nossa política de privacidade. Ao utilizar nosso serviço, você concorda com a coleta, uso e divulgação de suas informações pessoais conforme descrito em nossa política de privacidade."),
            Text("Limitação de Responsabilidade:"),
            Text("Nosso serviço é fornecido no estado em que se encontra, e não fazemos representações ou garantias de qualquer tipo, expressas ou implícitas, sobre a disponibilidade, confiabilidade, adequação ou precisão do serviço. Em nenhuma circunstância seremos responsáveis por quaisquer danos diretos, indiretos, consequenciais, especiais ou punitivos decorrentes do uso ou incapacidade de uso do serviço."),
            Text("Modificações nos Termos:"),
            Text("Podemos modificar estes termos a qualquer momento, mediante aviso prévio ou atualização no serviço. É responsabilidade sua revisar regularmente os termos atualizados. O uso contínuo do serviço após a publicação de quaisquer modificações constitui sua aceitação dessas modificações."),
            Text("Ao clicar em Aceitar ou ao continuar a usar nosso serviço, você reconhece que leu, entendeu e concordou com estes termos e condições. Se você não concorda com estes termos, por favor, não utilize nosso serviço."),
            Text("Obrigado por escolher nossos serviços e desejamos uma ótima experiência!"),
            CheckboxListTile(
              title: Text('Aceito os termos e condições'),
              value: _isChecked,
              activeColor: AppColors.primary,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _isChecked ? () => {_aceito(args)} : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (!_isChecked) {
                    return Colors.grey;
                  } else {
                    return AppColors.primary;
                  }
                }),
              ),
              child: Text("Aceito os termos"),
            )
          ],
        ),
      )),
    );
  }
}
